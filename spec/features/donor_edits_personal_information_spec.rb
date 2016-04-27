require "rails_helper"

feature "Donor edits personal information" do
  scenario "from profile" do
    donor = create(:donor, name: "old", email: "old@example.com")
    new_settings = {
      email: "new@example.com",
      name: "new",
    }

    visit root_path(as: donor)
    edit_profile(new_settings)

    expect(page).to have_success_flash
    expect(page).to have_text(new_settings[:email])
    expect(page).to have_text(new_settings[:address])
  end

  context "when the settings are invalid" do
    scenario "it prompts the user for corrections" do
      donor = create(:donor)

      visit profile_path(as: donor)
      edit_profile(email: "")

      expect(page).to have_email_errors
    end
  end

  context "changing to an unsupported zipcode" do
    it "rejects the change and prompts them to contact the team" do
      supported_zone = create(:zone, zipcode: "80205")
      location = create(:location, zipcode: supported_zone.zipcode)
      donor = create(:donor, location: location)

      visit profile_path(as: donor)
      edit_profile(zipcode: "80204")

      expect(page).to have_error_flash
      expect(page).to have_unsupported_zipcode_warning("80204")
    end
  end

  def have_unsupported_zipcode_warning(zipcode)
    have_text t("validations.locations.unsupported", zipcode: zipcode)
  end

  def have_success_flash
    have_text t("profiles.update.success")
  end

  def have_error_flash
    have_text t("profiles.update.error")
  end

  def edit_profile(attributes)
    click_on t("profiles.show.edit")

    fill_form_and_submit(:profile, :edit, attributes)
  end

  def have_email_errors
    have_text "is invalid"
  end
end
