require "rails_helper"
require "rake"

feature "Admin views pickup time", :rake do
  scenario "generated weekly" do
    zone = create(
      :zone,
      start_hour: 13,
      end_hour: 15,
      weekday: wednesday,
    )
    schedule_pickups!

    view_zone(zone)

    expect(page).to have_text("Wednesday between 1:00 pm and 3:00 pm")
  end

  def wednesday
    Weekday.find(3).value
  end

  def view_zone(zone)
    visit root_path(as: create(:user, :admin))
    click_on zone.zipcode
  end

  def schedule_pickups!
    Rake::Task["pickups:schedule"].invoke
  end

  before :all do
    Rake.application.rake_require "tasks/pickups"
    Rake::Task.define_task(:environment)
  end
end
