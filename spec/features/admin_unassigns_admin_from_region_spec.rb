require "rails_helper"

feature "Admin unassigns admin from region" do
  scenario "from the regions dashboard" do
    visit_regions_page_as_admin

    region = create_region(name: "My Region")
    to_be_deleted = create(:admin, name: "To Be Deleted")
    assign_admin_to_region(to_be_deleted, region)

    expect(page).to have_text("1 Administrator assigned")

    click_on region.name
    click_on t("region_admins.destroy.text")

    expect(page).to have_success_flash(to_be_deleted)

    expect(region.reload.region_admins).to be_empty
  end

  def have_success_flash(admin)
    have_text t("region_admins.destroy.success", admin_name: admin.name)
  end

  def assign_admin_to_region(admin, region)
    visit new_region_admin_path(region_id: region.id)

    select(admin.name, from: "region_admin_user_id")

    click_on("Assign Administrator")
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
