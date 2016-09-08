require "rails_helper"

feature "Admin creates region" do
  scenario "from the regions dashboard" do
    visit_regions_page_as_admin

    expect do
      create_region(name: "My Region")
    end.to change{Region.count}.from(0).to(1)
  end

  def visit_regions_page_as_admin
    visit root_path(as: create(:admin))
    click_on t("application.header.regions")
  end

  def create_region(**attributes)
    click_on(t("regions.index.new"))
    fill_form_and_submit(:region, :new, attributes)
  end
end
