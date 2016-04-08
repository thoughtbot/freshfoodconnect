require "rails_helper"

feature "Donor declines donation" do
  scenario "after signing up" do
    zone = create(:zone, :with_scheduled_pickups)

    sign_up_donor(zipcode: zone.zipcode, email: "user@example.com")
    decline_donation
    last_donation = Donation.last

    expect(last_donation).to have_attributes(
      confirmed?: false,
      declined?: true,
      pending?: false,
    )
    expect(last_donation.donor).to have_attributes(
      email: "user@example.com",
    )
    expect(page).to have_success_flash
    expect(page).to have_declined_status
  end

  def have_success_flash
    have_text t("confirmations.destroy.success")
  end

  def have_declined_status
    have_text t("donations.current.status.declined")
  end

  def decline_donation
    click_on t("donations.current.decline")
  end

  def sign_up_donor(zipcode:, email:)
    visit root_path

    fill_form_and_submit(:pre_registration, zipcode: zipcode)

    registration = attributes_for(:registration, email: email)
    fill_form_and_submit(:registration, registration)
  end
end
