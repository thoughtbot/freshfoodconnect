module ScheduledPickupsHelper
  def format_pickup_time(scheduled_pickup)
    TimeRange.new(
      start_at: scheduled_pickup.start_at,
      end_at: scheduled_pickup.end_at,
    )
  end
end
