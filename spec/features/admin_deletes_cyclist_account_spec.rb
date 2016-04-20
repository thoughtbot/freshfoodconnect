require "rails_helper"

feature "Admin deletes cyclist account" do
  scenario "from the Users list" do
    ensure_zone_exists!
    cyclist = create(:cyclist)

    visit_users_page
    delete_user(cyclist)

    within_role :cyclists do
      expect(page).not_to have_name(cyclist)
    end
    expect(page).to have_success_flash(cyclist)
  end

  def have_success_flash(user)
    have_text t("users.destroy.success", name: user.name)
  end

  def visit_users_page
    visit users_path(as: create(:admin))
  end

  def delete_user(user)
    within_record(user) do
      click_on t("users.delete.text")
    end
  end

  def ensure_zone_exists!
    create(:zone)
  end
end
