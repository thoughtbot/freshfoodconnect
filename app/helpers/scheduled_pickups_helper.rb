module ScheduledPickupsHelper
  def format_pickup_time(scheduled_pickup)
    start_at = scheduled_pickup.start_at
    end_at = scheduled_pickup.end_at
    time_format = "%l:%M %P"

    t(
      "scheduled_pickups.format",
      weekday: Date::DAYNAMES[start_at.wday],
      start_at: start_at.strftime(time_format),
      end_at: end_at.strftime(time_format),
    )
  end
end
