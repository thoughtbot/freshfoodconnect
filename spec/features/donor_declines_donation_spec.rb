require "rails_helper"

feature "Donor declines donation" do
  scenario "after signing up" do
    email = "user@example.com"
    zone = create(:zone, :with_scheduled_pickups)

    sign_up_donor(zipcode: zone.zipcode, email: email)
    decline_donation
    last_donation = Donation.last

    expect(last_donation).to be_declined
    expect(last_donation.donor).to belong_to(email)
    expect(page).to have_declined_status
    expect(page).to be_redirected_to_profile
    expect(page).not_to have_flash
  end

  def be_redirected_to_profile
    have_text t("profiles.show.edit")
  end

  scenario "directly from the edit page" do
    donation = create(:donation, :pending)

    edit_donation(donation)
    decline_donation

    expect(donation.reload).to be_declined
    expect(page).to be_redirected_to_profile
  end

  def be_redirected_to_profile
    have_text t("profiles.show.edit")
  end

  def edit_donation(donation)
    visit edit_donation_path(donation, as: donation.donor)
  end

  def belong_to(email)
    have_attributes(email: email)
  end

  def be_declined
    have_attributes(
      confirmed?: false,
      declined?: true,
      pending?: false,
    )
  end

  def have_declined_status
    have_text t("donations.statuses.declined")
  end

  def decline_donation
    click_on t("donations.decline.text")
  end

  def sign_up_donor(zipcode:, email:)
    visit root_path

    fill_form_and_submit(:pre_registration, zipcode: zipcode)

    registration = attributes_for(:registration, email: email)
    fill_form_and_submit(:registration, registration)
  end
end
