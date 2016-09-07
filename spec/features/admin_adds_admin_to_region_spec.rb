require "rails_helper"

feature "Admin adds admin for region" do
  scenario "from the regions dashboard" do
    visit_regions_page_as_admin

    region = create_region(name: "My Region")
    current_admin = create(:admin, name: "Current Admin")
    new_admin = create(:user, name: "New Admin")
    assign_admin_to_region(current_admin, region)

    expect(page).to have_text("1 Administrator assigned")

    assign_admin_to_region(new_admin, region)

    expect(page).to have_success_flash(new_admin)

    expect(region.admins.length).to eq(2)
  end

  def have_success_flash(admin)
    have_text t("region_admins.update.success", admin_name: admin.name)
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
