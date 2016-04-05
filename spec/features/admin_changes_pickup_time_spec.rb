require "rails_helper"

feature "Admin changes pickup time" do
  scenario "from delivery zone page" do
    tuesday = Date.new(2016, 4, 5).beginning_of_day
    wednesday = tuesday + 1.day
    delivery_zone = create(:delivery_zone, start_hour: 0, end_hour: 24, start_day:

    visit root_path(as: create(:user, :admin))
    edit_pickup_location(delivery_zone)
    update_pickup_date(day: wednesday, time_range: "at midnight")

    expect(page).to have_text("at midnight")
    expect(page).to have_text("Wednesday")
  end

  def schedule_pickups!
    Rake::Task["pickups:schedule"].invoke
  end

  def update_pickup_date(day:, time_range:)
    fill_form_and_submit(
      :scheduled_pickup,
      scheduled_for: day,
      time_range: time_range,
    )
  end

  def edit_pickup_location(delivery_zone)
    click_on delivery_zone.zipcode

    within "[data-role=pickup-location]" do
      click_on t(".pickup.edit")
    end
  end
end
