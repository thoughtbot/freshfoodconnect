require "rails_helper"

feature "Admin promotes donor to admin account" do
  scenario "from the Users list" do
    donor = create(:donor)

    visit_users_page
    promote_user(donor)

    within_role :admins do
      expect(page).to have_name(donor)
      expect(page).to have_demote_button
    end
    expect(page).to have_success_flash(donor)
  end

  def have_success_flash(donor)
    have_text t("promotions.create.success", name: donor.name)
  end

  def have_demote_button
    have_text t("users.demote.text")
  end

  def visit_users_page
    visit users_path(as: create(:admin))
  end

  def promote_user(user)
    within_record(user) do
      click_on t("users.promote.text")
    end
  end
end
