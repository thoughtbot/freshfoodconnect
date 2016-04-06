require "rails_helper"

feature "Admin schedules pickup time" do
  scenario "from the dashboard" do
    weekday = Weekday.all.first
    start_hour = Hour.all.first
    end_hour = Hour.all.last
    delivery_zone = create(
      :delivery_zone,
      :unscheduled,
      start_hour: start_hour.value,
      end_hour: end_hour.value,
      weekday: weekday.value,
      zipcode: "90210",
    )

    visit delivery_zone_path(delivery_zone, as: create(:user, :admin))
    schedule_pickup_with_defaults

    expect(page).to have_text(delivery_zone.zipcode)
    expect(page).to have_text(start_hour.label)
    expect(page).to have_text(end_hour.label)
    expect(page).to have_text(weekday.label)
  end

  def schedule_pickup_with_defaults
    click_on t("helpers.submit.scheduled_pickup.create")
  end
end
