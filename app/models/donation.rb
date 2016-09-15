class Donation < ActiveRecord::Base
  time_for_a_boolean :confirmed
  time_for_a_boolean :declined
  time_for_a_boolean :picked_up
  time_for_a_boolean :requested

  belongs_to :scheduled_pickup, touch: true
  belongs_to :location, touch: true
  has_one :donor, through: :location, source: :user
  has_one :zone, through: :scheduled_pickup

  enum size: %i[small medium large]

  validates :location, presence: true
  validates :scheduled_pickup,
    presence: true,
    uniqueness: { scope: :location_id }

  delegate(:address, :geocoded?, :latitude, :longitude, to: :location)
  delegate(:date, :time_range, to: :scheduled_pickup)

  def self.confirmed
    where(<<-SQL)
      confirmed_at IS NOT NULL AND (
        declined_at IS NULL OR
        confirmed_at > declined_at
      )
    SQL
  end

  def self.current
    joins(:scheduled_pickup).merge(ScheduledPickup.current)
  end

  def self.pending
    where(confirmed_at: nil, declined_at: nil)
  end

  def self.scheduled_for_pick_up_within(hours:)
    cutoff = hours.hours.from_now

    joins(:scheduled_pickup).
      where(
        "scheduled_pickups.start_at BETWEEN :now AND :cutoff",
        now: Time.current,
        cutoff: cutoff.end_of_day,
      )
  end

  def unrequested?
    !requested?
  end

  def declined?
    declined_at.present? && declined_after_confirmed?
  end

  def confirmed?
    confirmed_at.present? && confirmed_after_declined?
  end

  def pickup_date
    scheduled_pickup.start_at.to_date
  end

  def pending?
    ! (confirmed || declined)
  end

  private

  def declined_after_confirmed?
    time_or_epoch(declined_at) > time_or_epoch(confirmed_at)
  end

  def confirmed_after_declined?
    time_or_epoch(confirmed_at) >= time_or_epoch(declined_at)
  end

  def time_or_epoch(timestamp)
    timestamp.presence || Time.at(0)
  end
end
