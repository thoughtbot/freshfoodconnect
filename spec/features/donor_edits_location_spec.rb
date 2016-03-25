require "rails_helper"

feature "Donor edits location" do
  scenario "from profile" do
    donor = create(:user, zipcode: "90210")

    visit root_path(as: donor)
    click_on_profile
    submit_pickup_location(
      address: "123 Fake Street Denver CO",
      zipcode: "80221",
      notes: "on my porch",
    )

    expect(page).to have_pickup_time_text
    expect(page).to have_supported_zipcode_text("80221")
  end

  context "when the location is invalid" do
    scenario "it prompts the user for corrections" do
      donor = create(:user)

      visit profile_path(as: donor)
      submit_pickup_location(address: "", zipcode: "")

      expect(page).to have_address_errors
    end
  end

  def have_supported_zipcode_text(zipcode)
    have_text t("profiles.show.supported", zipcode: zipcode)
  end

  def click_on_profile
    click_on t("application.navigation.profile")
  end

  def submit_pickup_location(address:, zipcode:, notes: "")
    fill_form_and_submit(
      :location,
      :new,
      address: address,
      zipcode: zipcode,
      notes: notes,
    )
  end

  def have_pickup_time_text
    have_text t("profiles.show.pickup")
  end

  def have_address_errors
    have_text "can't be blank"
  end
end
