require "rails_helper"

feature "Admin deletes admin" do
  scenario "from the Users page" do
    to_be_deleted = create(:admin, name: "To Be Deleted")

    visit_users_page_as_admin
    within_record(to_be_deleted) do
      click_on t("users.delete.text")
    end

    expect(page).to have_success_flash(to_be_deleted)
    within_role :admins do
      expect(page).not_to have_name(to_be_deleted)
    end
  end

  def have_success_flash(admin)
    have_text t("users.destroy.success", name: admin.name)
  end

  def visit_users_page_as_admin
    visit users_path(as: create(:admin))
  end
end
