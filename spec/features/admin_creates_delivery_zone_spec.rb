require "rails_helper"

feature "Admin creates delivery zone" do
  scenario "from the dashboard" do
    admin = create(:user, :admin)

    visit root_path(as: admin)
    create_delivery_zone(zipcode: "90210")

    expect(page).to have_zipcode("90210")
  end

  scenario "displays validation errors" do
    admin = create(:user, :admin)
    delivery_zone = create(:delivery_zone, zipcode: "90210")

    visit root_path(as: admin)
    create_delivery_zone(zipcode: delivery_zone.zipcode)

    expect(page).to have_errors
  end

  def create_delivery_zone(zipcode:)
    click_on t("delivery_zones.index.new")

    fill_form_and_submit(:delivery_zone, :new, zipcode: zipcode)
  end

  def have_errors
    have_text "has already been taken"
  end

  def have_zipcode(zipcode)
    have_text(zipcode)
  end
end
