require "rails_helper"

feature "Donor signs up" do
  context "for supported zipcode" do
    scenario "they're notified and prompted for their address" do
      supported_location = build(:location, :supported)

      visit root_path
      pre_register_with_zipcode(supported_location.zipcode)
      register_donor(address: supported_location.address)

      expect(page).to have_pickup_text
    end
  end

  context "for unsupported zipcode" do
    scenario "they're put on the waiting list" do
      unsupported_zipcode = "90210"

      visit root_path
      sign_up_with_zipcode(unsupported_zipcode)

      expect(page).to have_unsupported_zipcode_text(unsupported_zipcode)
    end
  end

  def register_donor(address:)
    attributes = attributes_for(:registration).merge(address: address)

    fill_form_and_submit(:registration, :new, attributes)
  end

  def have_unsupported_zipcode_text(zipcode)
    have_text t("profiles.show.unsupported", zipcode: zipcode)
  end

  def have_supported_zipcode_text(zipcode)
    have_text t("profiles.show.supported", zipcode: zipcode)
  end

  def pre_register_with_zipcode(zipcode)
    fill_form_and_submit(:pre_registration, :new, zipcode: zipcode)
  end

  def have_pickup_text
    have_text t("profiles.show.pickup")
  end
end
