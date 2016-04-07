require "rails_helper"

feature "Donor confirms donation" do
  scenario "after signing up" do
    zone = create(:zone, :with_scheduled_pickups)

    sign_up_donor(zipcode: zone.zipcode, email: "user@example.com")
    confirm_donation
    last_donation = Donation.last

    expect(last_donation).to have_attributes(
      confirmed?: true,
      declined?: false,
      pending?: false,
    )
    expect(last_donation.donor).to have_attributes(
      email: "user@example.com",
    )
    expect(page).to have_success_flash
    expect(page).to have_confirmed_status
  end

  def have_success_flash
    have_text t("confirmations.create.success")
  end

  def have_confirmed_status
    have_text t("donations.current.status.confirmed")
  end

  def confirm_donation
    click_on t("donations.current.confirm")
  end

  def sign_up_donor(zipcode:, email:)
    visit root_path

    fill_form_and_submit(:pre_registration, zipcode: zipcode)

    registration = attributes_for(:registration, email: email)
    fill_form_and_submit(:registration, registration)
  end
end
