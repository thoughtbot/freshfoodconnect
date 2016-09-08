require "rails_helper"

feature "Admin deletes region" do
  scenario "from the regions dashboard" do
    create(:region, :with_zones)

    visit_regions_page_as_admin

    expect do
      click_on t("regions.destroy.text")
    end.to change{ Region.count }.from(1).to(0)
  end

  def visit_regions_page_as_admin
    visit root_path(as: create(:admin))
    click_on t("application.header.regions")
  end
end
