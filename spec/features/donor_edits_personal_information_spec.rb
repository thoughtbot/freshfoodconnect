require "rails_helper"

feature "Donor edits personal information" do
  scenario "from profile" do
    donor = create(
      :donor,
      name: "old",
      email: "old@example.com",
      phone_number: "+15555555555",
    )
    new_settings = {
      email: "new@example.com",
      name: "new",
      phone_number: "(555)-555-5555",
    }

    visit root_path(as: donor)
    edit_profile(new_settings)

    expect(page).to have_text(new_settings[:address])
    expect(page).to have_text(new_settings[:email])
    expect(page).to have_text(new_settings[:phone_number])
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
