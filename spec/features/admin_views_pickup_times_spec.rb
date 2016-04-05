require "rails_helper"
require "rake"

feature "Admin views pickup time" do
  before :all do
    Rake.application.rake_require "tasks/pickups"
    Rake::Task.define_task(:environment)
  end

  scenario "generated weekly" do
    delivery_zone = create(
      :delivery_zone,
      start_hour: 13,
      end_hour: 16,
      weekday: wednesday,
    )
    schedule_pickups!

    view_delivery_zone(delivery_zone)

    expect(page).to have_text("between 1:00 PM and 3:00 PM")
    expect(page).to have_text("Wednesday")
  end

  def wednesday
    Date::DAYNAMES.index("Wednesday")
  end

  def schedule_pickups!
    Rake::Task["pickups:schedule"].invoke
  end

  def view_delivery_zone(delivery_zone)
    visit root_path(as: create(:user, :admin))
    click_on delivery_zone.zipcode
  end
end
