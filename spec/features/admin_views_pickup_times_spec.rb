require "rails_helper"
require "rake"

feature "Admin views pickup time" do
  scenario "generated weekly" do
    friday = thursday + 1.day

    Timecop.freeze(thursday) do
      zone = create(
        :zone,
        start_hour: 13,
        end_hour: 15,
        weekday: friday.wday,
      )
      schedule_pickups!

      view_zone(zone)

      expect(page).
        to have_text("Friday April 15, 2016 between 1:00 pm and 3:00 pm")
      expect(page).
        to have_confirmation_time("Wednesday April 13, 2016 at 1:00 pm")
    end
  end

  def have_confirmation_time(time)
    have_text t("scheduled_pickups.show.confirmation.time", time: time)
  end

  def thursday
    Date.new(2016, 4, 14).beginning_of_day
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
