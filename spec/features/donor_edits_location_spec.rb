require "rails_helper"

feature "Donor edits location" do
  scenario "from profile" do
    delivery_zone = create(:delivery_zone)
    location = create(:location, :supported)
    donor = create(:user, location: location)
    new_pickup_location = {
      address: "123 Fake Street Denver CO",
      zipcode: delivery_zone.zipcode,
      notes: "on my porch",
    }

    visit root_path(as: donor)
    click_on_profile
    edit_pickup_location(new_pickup_location)

    expect(page).to have_text(new_pickup_location[:address])
    expect(page).to have_text(new_pickup_location[:zipcode])
    expect(page).to have_text(new_pickup_location[:notes])
  end

  context "when the location is invalid" do
    scenario "it prompts the user for corrections" do
      donor = create(:donor)

      visit profile_path(as: donor)
      edit_pickup_location(address: "", zipcode: "")

      expect(page).to have_address_errors
    end
  end

  def click_on_profile
    click_on t("application.main_header.profile")
  end

  def edit_pickup_location(address:, zipcode:, notes: "")
    click_on t("profiles.show.edit")

    fill_form_and_submit(
      :profile,
      :edit,
      address: address,
      zipcode: zipcode,
      notes: notes,
    )
  end

  def have_address_errors
    have_text "can't be blank"
  end
end
