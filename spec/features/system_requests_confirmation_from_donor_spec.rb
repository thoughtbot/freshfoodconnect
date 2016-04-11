require "rails_helper"
require "rake"

feature "System requests confirmation from donor" do
  around do |example|
    Timecop.freeze { example.run }
  end

  scenario "48 hours in advance of a scheduled pickup" do
    scheduled_pickup = schedule_pickup(48.hours.from_now)
    donation = create(:donation, :pending, scheduled_pickup: scheduled_pickup)
    donor = donation.donor
    ensure_donor_is_signed_in(donor)

    schedule_initial_confirmation_requests!
    open_email(donor.email)
    edit_donation_through_email_link

    expect(page).to have_donation_edit_header
    expect(current_email.subject).
      to have_confirmation_request_subject_for(donation)
  end

  def have_donation_edit_header
    have_text t("donations.edit.header")
  end

  def edit_donation_through_email_link
    current_email.click_on t("donations_mailer.request_confirmation.edit")
  end

  def ensure_donor_is_signed_in(donor)
    visit root_path(as: donor)
  end

  def have_confirmation_request_subject_for(donation)
    subject = t(
      "donations_mailer.request_confirmation.subject",
      range: donation.time_range,
    )

    eq(subject)
  end

  def schedule_initial_confirmation_requests!
    Rake::Task["confirmations:request"].invoke
  end

  def schedule_pickup(start_at)
    create(:scheduled_pickup, start_at: start_at, end_at: start_at - 1.hour)
  end

  before :all do
    Rake.application.rake_require "tasks/confirmations"
    Rake::Task.define_task(:environment)
  end
end
