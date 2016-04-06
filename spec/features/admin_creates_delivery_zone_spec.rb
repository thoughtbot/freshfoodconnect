require "rails_helper"

feature "Admin creates delivery zone" do
  scenario "from the dashboard" do
    weekday = Weekday.all.first
    start_hour = Hour.all.first
    end_hour = Hour.all.last

    visit_homepage_as_admin
    create_delivery_zone(
      zipcode: "90210",
      start_hour: start_hour.label,
      end_hour: end_hour.label,
      weekday: weekday.label,
    )

    expect(page).to have_text("90210")
    expect(page).to have_text(start_hour.label)
    expect(page).to have_text(end_hour.label)
    expect(page).to have_text(weekday.label)
  end

  scenario "displays validation errors" do
    delivery_zone = create(:delivery_zone, zipcode: "90210")

    visit_homepage_as_admin
    create_delivery_zone(zipcode: delivery_zone.zipcode)

    expect(page).to have_errors
  end

  def visit_homepage_as_admin
    visit root_path(as: create(:user, :admin))
  end

  def create_delivery_zone(**options)
    attributes = options.reverse_merge(
      start_hour: Hour.all.first.label,
      end_hour: Hour.all.last.label,
      weekday: Weekday.all.first.label,
    )
    click_on t("delivery_zones.index.new")

    fill_form_and_submit(:delivery_zone, :new, attributes)
  end

  def have_errors
    have_text "has already been taken"
  end
end
