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

  def edit_profile(attributes)
    click_on t("profiles.show.edit")

    fill_form_and_submit(:profile, :edit, attributes)
  end

  def have_email_errors
    have_text "is invalid"
  end
end
