module ScheduledPickupsHelper
  def format_pickup_time(scheduled_pickup)
    start_at = scheduled_pickup.start_at
    end_at = scheduled_pickup.end_at
    time_format = "%l:%M %P"

    t(
      "scheduled_pickups.format",
      weekday: Weekday.find(start_at.wday).label,
      start_at: start_at.strftime(time_format),
      end_at: end_at.strftime(time_format),
    )
  end
end
