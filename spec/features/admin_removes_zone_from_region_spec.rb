require "rails_helper"

feature "Admin removes zone from region" do
  scenario "dissociates zone with region" do
    admin = create(:admin)
    region = create(:region)
    zone = create(:zone, region: region)

    visit_region_page_as(region, admin)
    click_on(t("region_zones.destroy.text"))

    zone.reload
    expect(zone.region).to be_nil
  end

  def visit_region_page_as(region, user)
    visit root_path(as: user)
    click_on t("application.header.regions")
    click_on region.name
  end

end
