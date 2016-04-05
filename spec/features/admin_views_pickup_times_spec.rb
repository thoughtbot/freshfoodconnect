require "rails_helper"
require "rake"

feature "Admin views pickup time", :rake do
  scenario "generated weekly" do
    delivery_zone = create(
      :delivery_zone,
      start_hour: 13,
      end_hour: 15,
      weekday: wednesday,
    )
    schedule_pickups!

    view_delivery_zone(delivery_zone)

    expect(page).to have_text("Wednesday from 1:00 pm to 3:00 pm")
  end

  def wednesday
    Date::WEEKDAYS["wednesday"]
  end

  def view_delivery_zone(delivery_zone)
    visit root_path(as: create(:user, :admin))
    click_on delivery_zone.zipcode
  end

  def schedule_pickups!
    Rake::Task["pickups:schedule"].invoke
  end

  before :all do
    Rake.application.rake_require "tasks/pickups"
    Rake::Task.define_task(:environment)
  end
end
