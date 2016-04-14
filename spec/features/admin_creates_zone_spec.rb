require "rails_helper"

feature "Admin creates zone" do
  scenario "from the dashboard" do
    weekday = Weekday.all.first
    start_hour = Hour.all.first
    end_hour = Hour.all.last

    visit_homepage_as_admin
    create_zone(
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
    zone = create(:zone, zipcode: "90210")

    visit_homepage_as_admin
    create_zone(zipcode: zone.zipcode)

    expect(page).to have_errors
  end

  def visit_homepage_as_admin
    visit root_path(as: create(:admin))
  end

  def create_zone(**options)
    attributes = options.reverse_merge(
      start_hour: Hour.all.first.label,
      end_hour: Hour.all.last.label,
      weekday: Weekday.all.first.label,
    )
    click_on t("zones.index.new")

    fill_form_and_submit(:zone, :new, attributes)
  end

  def have_errors
    have_text "has already been taken"
  end
end
