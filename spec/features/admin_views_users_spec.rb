require "rails_helper"

feature "Admin views users" do
  scenario "grouped by role" do
    admin = create(:admin)
    donor = create(:donor)
    cyclist = create(:cyclist)

    visit_users_page(as: admin)

    within_user_group :admins do
      expect(page).to have_user(admin)
    end
    within_user_group :donors do
      expect(page).to have_user(donor)
    end
    within_user_group :cyclists do
      expect(page).to have_user(cyclist)
    end
  end

  def within_user_group(group, &block)
    within("[data-role=#{group}]", &block)
  end

  def have_user(user)
    have_text user.name
  end

  def visit_users_page(as:)
    visit root_path(as: as)
    click_on t("application.header.users")
  end
end
