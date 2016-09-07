require "rails_helper"

feature "Admin assigns admin to region" do
  scenario "from the regions dashboard" do
    visit_regions_page_as_admin

    region = create_region(name: "My Region")
    admin = create(:admin)

    expect(page).to have_text("No administrator set")

    expect(region.admins).to be_empty
    assign_admin_to_region(admin, region)
    region.reload
    expect(region.admins.first).to eq(admin)
  end

  def assign_admin_to_region(admin, region)
    visit new_region_admin_path(region_id: region.id)

    select(admin.name, from: "region_admin_user_id")

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
