require "rails_helper"

feature "Donor confirms donation" do
  scenario "after signing up" do
    email = "user@example.com"
    zone = create(:zone, :with_scheduled_pickups)

    sign_up_donor(zipcode: zone.zipcode, email: email)
    confirm_donation
    last_donation = Donation.last

    expect(last_donation.donor).to belong_to(email)
    expect(last_donation).to be_confirmed
    expect(page).to have_confirmed_status
    expect(page).to have_size_options
    expect(page).not_to have_flash
  end

  scenario "directly from the edit page" do
    donation = create(:donation, :pending)

    edit_donation(donation)
    confirm_donation

    expect(donation.reload).to be_confirmed
  end

  def edit_donation(donation)
    visit edit_donation_path(donation, as: donation.donor)
  end

  def have_size_options
    have_text t("simple_form.options.donation.size.medium")
  end

  def have_confirmed_status
    have_text t("donations.statuses.confirmed")
  end

  def be_sent_to(email)
    have_attributes(to: [email])
  end

  def belong_to(email)
    have_attributes(email: email)
  end

  def be_confirmed
    have_attributes(
      confirmed?: true,
      declined?: false,
      pending?: false,
    )
  end

  def confirm_donation
    click_on t("donations.confirm.text")
  end

  def sign_up_donor(zipcode:, email:)
    visit root_path

    fill_form_and_submit(:pre_registration, zipcode: zipcode)

    registration = attributes_for(:registration, email: email)
    fill_form_and_submit(:registration, registration)
  end
end
