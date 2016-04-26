require "rails_helper"

feature "Admin demotes admin to donor account" do
  scenario "from the Users list" do
    admin = create(:donor, admin: true)

    visit_users_page
    demote_user(admin)

    within_role :donors do
      expect(page).to have_name(admin)
      expect(page).to have_promote_button
    end
    expect(page).to have_success_flash(admin)
  end

  def have_success_flash(user)
    have_text t("promotions.destroy.success", name: user.name)
  end

  def have_promote_button
    have_text t("users.promote.text")
  end

  def visit_users_page
    visit users_path(as: create(:admin))
  end

  def demote_user(user)
    within_role :admins do
      within_record(user) do
        click_on t("users.demote.text")
      end
    end
  end
end
