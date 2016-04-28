require "rails_helper"

feature "Admin schedules pickup time" do
  scenario "from the dashboard" do
    weekday = Weekday.all.first
    start_hour = Hour.all.first
    end_hour = Hour.all.last
    zone = create(
      :zone,
      :unscheduled,
      start_hour: start_hour.value,
      end_hour: end_hour.value,
      weekday: weekday.value,
      zipcode: "90210",
    )

    visit zone_path(zone, as: create(:admin))
    schedule_pickup_with_defaults

    expect(page).to have_success_flash
    expect(page).to have_text(zone.zipcode)
    expect(page).to have_text(start_hour.label)
    expect(page).to have_text(end_hour.label)
    expect(page).to have_text(weekday.label)
  end

  def have_success_flash
    have_text t("scheduled_pickups.create.success")
  end

  def schedule_pickup_with_defaults
    click_on t("helpers.submit.scheduled_pickup.create")
  end
end
