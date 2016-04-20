require "rails_helper"

feature "Admin views users" do
  scenario "grouped by role" do
    admin = create(:admin)
    donor = create(:donor)
    cyclist = create(:cyclist)
    deleted = create(:cyclist, :deleted)

    visit_users_page(as: admin)

    expect(page).not_to have_name(deleted)
    within_role :admins do
      expect(page).to have_name(admin)
    end
    within_role :donors do
      expect(page).to have_name(donor)
    end
    within_role :cyclists do
      expect(page).to have_name(cyclist)
    end
  end

  def visit_users_page(as:)
    visit root_path(as: as)
    click_on t("application.header.users")
  end
end
