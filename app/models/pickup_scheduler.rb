class PickupScheduler
  def initialize(zone)
    @zone = zone
  end

  def schedule!
    ActiveRecord::Base.transaction do
      scheduled_pickup.save!
      enroll_donors!
    end
  end

  def scheduled_pickup
    @scheduled_pickup ||= current_scheduled_pickup || build_scheduled_pickup
  end

  private

  attr_reader :zone

  delegate(
    :current_scheduled_pickup,
    :end_hour,
    :start_hour,
    :weekday,
    to: :zone,
  )

  def enroll_donors!
    zone.locations.each do |location|
      DonorEnrollment.new(location: location).save!
    end
  end

  def build_scheduled_pickup
    zone.scheduled_pickups.build(
      start_at: start_time,
      end_at: end_time,
    )
  end

  def end_time
    pickup_day + end_hour.hours
  end

  def start_time
    pickup_day + start_hour.hours
  end

  def pickup_day
    Chronic.parse(
      day_of_week,
      conext: :next,
      now: Time.current,
    ).beginning_of_day
  end

  def day_of_week
    Weekday.find(weekday)
  end
end
