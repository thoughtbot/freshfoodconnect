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
    expect(page).to have_confirmation_flash
    expect(page).to have_confirmed_status
    expect(page).to have_size_options
  end

  def have_size_options
    have_text t("donations.sizes.medium")
  end

  def have_confirmation_flash
    have_text t("confirmations.create.success")
  end

  def have_confirmed_status
    have_text t("donations.status.confirmed")
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
