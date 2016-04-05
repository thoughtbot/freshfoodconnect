class PickupScheduler
  def initialize(delivery_zone)
    @delivery_zone = delivery_zone
  end

  def schedule!
    if current_scheduled_pickup.nil?
      schedule_pickup!
    end
  end

  private

  attr_reader :delivery_zone

  delegate(
    :current_scheduled_pickup,
    :end_hour,
    :start_hour,
    :weekday,
    to: :delivery_zone,
  )

  def schedule_pickup!
    delivery_zone.scheduled_pickups.create!(
      start_at: start_time,
      end_at: end_time,
    )
  end

  def end_time
    scheduled_date + end_hour.hours
  end

  def start_time
    scheduled_date + start_hour.hours
  end

  def scheduled_date
    start_of_week + offset_into_week
  end

  def offset_into_week
    weekday.days
  end

  def start_of_week
    Time.current.sunday.beginning_of_day
  end
end
