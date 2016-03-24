require "rails_helper"

feature "Donor signs up" do
  context "for supported zipcode" do
    scenario "they're notified and prompted for their address" do
      supported_zipcode = User::SUPPORTED_ZIPCODES.first

      visit root_path
      click_on_sign_up
      register_donor(email: "user@example.com", zipcode: supported_zipcode)

      expect(page).to have_supported_zipcode_text(supported_zipcode)
    end
  end

  context "for unsupported zipcode" do
    scenario "they're put on the waiting list" do
      unsupported_zipcode = "90210"

      visit root_path
      click_on_sign_up
      register_donor(email: "user@example.com", zipcode: unsupported_zipcode)

      expect(page).to have_unsupported_zipcode_text(unsupported_zipcode)
    end
  end

  def register_donor(email:, zipcode:)
    attributes = attributes_for(:user, email: email, zipcode: zipcode)

    fill_form_and_submit(
      :user,
      :new,
      attributes.slice(
        :email,
        :zipcode,
        :password,
      ),
    )
  end

  def have_unsupported_zipcode_text(zipcode)
    have_text t("profiles.show.unsupported", zipcode: zipcode)
  end

  def have_supported_zipcode_text(zipcode)
    have_text t("profiles.show.supported", zipcode: zipcode)
  end

  def click_on_sign_up
    click_on t("marketing.index.sign_up")
  end
end
