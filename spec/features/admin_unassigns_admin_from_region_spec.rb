require 'rails_helper'

feature 'Admin unassigns admin to region' do
  scenario 'from the regions dashboard' do
    visit_regions_page_as_admin

    region = create_region(name: 'My Region')
    to_be_deleted = create(:admin, name: "To Be Deleted")
    assign_admin_to_region(to_be_deleted, region)

    expect(page).to have_text("Administrator #{to_be_deleted.name} <#{to_be_deleted.email}>")

    click_on t("region_admin.destroy.text")

    expect(page).to have_success_flash(to_be_deleted)

    expect(region.reload.admin).to be_nil
  end

  def have_success_flash(admin)
    have_text t("region_admin.destroy.success", admin_name: admin.name)
  end

  def assign_admin_to_region(admin, region)
    visit new_region_admin_path(region)

    select(admin.name, from: "Admin")

    click_on(t("helpers.submit.region_admin.create"))
  end

  def visit_regions_page_as_admin
    visit root_path(as: create(:admin))
    click_on t('application.header.regions')
  end

  def create_region(**attributes)
    click_on(t('regions.index.new'))
    fill_form_and_submit(:region, :new, attributes)

    Region.last
  end
end
