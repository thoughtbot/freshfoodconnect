require "rails_helper"

feature "Admin adds zone to region" do
  context "when there are unassociated zones" do
    scenario "associates zone with region" do
      admin = create(:admin)
      region = create(:region)
      zone = create(:zone, region: nil)

      visit_region_page_as(region, admin)
      click_on(t("regions.show.add_zone"))

      select(zone.zipcode)
      click_on(t("helpers.submit.region_zone.create"))

      zone.reload
      expect(zone.region).to eq(region)
    end
  end

  context "when there are no unassociated zones" do
    scenario "shows an appropriate message" do
      admin = create(:admin)
      region = create(:region)
      create(:zone, region: region)

      visit_region_page_as(region, admin)

      expect(page).not_to have_content(t("regions.show.add_zone"))
      expect(page).to have_content(t("regions.show.no_unassociated_zones"))
    end
  end

  def visit_region_page_as(region, user)
    visit root_path(as: user)
    click_on t("application.header.regions")
    click_on region.name
  end
end
