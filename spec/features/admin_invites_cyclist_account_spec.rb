require "rails_helper"

feature "Admin creates cyclist account" do
  context "with valid attributes" do
    scenario "from the users page" do
      invite_cyclist(name: "Jane Q. Cyclist", email: "cyclist@example.com")

      expect(page).to have_success_flash
      expect(page).to have_text new_password_url
    end
  end

  context "with invalid attributes" do
    scenario "presents the admin with validation errors" do
      invite_cyclist(email: "")

      expect(page).to have_validation_errors
    end
  end

  def have_success_flash
    have_text t("cyclist_invitations.create.success")
  end

  def invite_cyclist(attributes)
    create(:zone)
    visit users_path(as: create(:admin))

    click_on t("users.cyclists.new")

    fill_form_and_submit(:cyclist_invitation, :new, attributes)
  end

  def have_validation_errors
    have_text "is invalid"
  end
end
