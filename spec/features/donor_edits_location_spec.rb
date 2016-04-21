require "rails_helper"

feature "Donor edits location" do
  scenario "from profile" do
    zone = create(:zone, zipcode: "80205")
    location = create(:location, :supported)
    donor = create(:user, location: location)
    new_pickup_location = {
      address: "123 Fake St.",
      zipcode: zone.zipcode,
      notes: "on my porch",
    }
    coordinates = {
      latitude: 39.8,
      longitude: -104.6,
    }
    stub_geocoding_for("123 Fake St. #{zone.zipcode}", coordinates)

    visit root_path(as: donor)
    click_on_profile
    edit_pickup_location(new_pickup_location)

    expect(location.reload).to have_attributes(coordinates)
    expect(page).to have_text(new_pickup_location[:address])
    expect(page).to have_text(new_pickup_location[:notes])
    expect(page).to have_text(new_pickup_location[:zipcode])
  end

  context "when the location is invalid" do
    scenario "it prompts the user for corrections" do
      donor = create(:donor)

      visit profile_path(as: donor)
      edit_pickup_location(address: "", zipcode: "")

      expect(page).to have_address_errors
    end
  end

  def have_supported_zipcode_text(zipcode)
    have_text t("profiles.show.supported", zipcode: zipcode)
  end

  def click_on_profile
    click_on t("application.header.profile")
  end

  def edit_pickup_location(**attributes)
    click_on t("profiles.show.edit")

    fill_form_and_submit(:profile, :edit, attributes)
  end

  def have_address_errors
    have_text "can't be blank"
  end
end
