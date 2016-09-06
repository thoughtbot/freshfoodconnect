require "rails_helper"

feature "Admin assigns admin to region" do
  scenario "from the regions dashboard" do
    visit_regions_page_as_admin

    region = create_region(name: "My Region")
    admin = create(:admin)

    expect(page).to have_text("No administrator set")

    expect(region.admin).to be_nil
    assign_admin_to_region(admin, region)
    region.reload
    expect(region.admin).to eq(admin)
  end

  def assign_admin_to_region(admin, region)
    visit new_region_admin_path(region)

    select(admin.name, from: "Admin")

    click_on(t("helpers.submit.region_admin.create"))
  end

  def visit_regions_page_as_admin
    visit root_path(as: create(:admin))
    click_on t("application.header.regions")
  end

  def create_region(**attributes)
    click_on(t("regions.index.new"))
    fill_form_and_submit(:region, :new, attributes)

    Region.last
  end
end
