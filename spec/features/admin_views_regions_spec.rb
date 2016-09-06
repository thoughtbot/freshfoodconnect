require "rails_helper"

feature "Admin views regions" do
  context "when there are regions" do
    scenario "shows a list of regions" do
      admin = create(:admin)
      region_1 = create(:region)
      region_2 = create(:region, :with_zones)

      visit_regions_page_as(admin)

      within ".regions a.region-tile:first" do
        expect(page).to have_name(region_1)
        expect(page).to have_zipcode_count(region_1)
      end

      within ".regions a.region-tile:last" do
        expect(page).to have_name(region_2)
        expect(page).to have_zipcode_count(region_2)
      end
    end
  end

  context "when there are no regions" do
    scenario "shows an appropriate message" do
      admin = create(:admin)

      visit_regions_page_as(admin)

      expect(page).to have_content(t("regions.index.no_regions"))
    end
  end

  def visit_regions_page_as(user)
    visit root_path(as: user)
    click_on t("application.header.regions")
  end

  def have_zipcode_count(record)
    zipcode_count = t("regions.region.zones", count: record.zones.count)
    have_content(zipcode_count)
  end
end
