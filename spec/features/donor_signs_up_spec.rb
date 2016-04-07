require "rails_helper"

feature "Donor signs up" do
  context "for supported zipcode" do
    scenario "they're notified and prompted for their address" do
      zone = create(:zone)
      supported_location = build(:location, zone: zone)
      user = build(:user)

      visit root_path
      pre_register_with_zipcode(zone.zipcode)
      register_donor(address: supported_location.address, email: user.email)

      expect(page).to have_text(user.email)
    end
  end

  def register_donor(address:, email:)
    attributes = attributes_for(:registration).
      merge(address: address, email: email)

    fill_form_and_submit(:registration, :new, attributes)
  end

  def pre_register_with_zipcode(zipcode)
    fill_form_and_submit(:pre_registration, :new, zipcode: zipcode)
  end

  def have_pickup_text
    have_text t("profiles.show.pickup")
  end
end
