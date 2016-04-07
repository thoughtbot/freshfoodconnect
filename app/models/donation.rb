class Donation < ActiveRecord::Base
  time_for_a_boolean :confirmed
  time_for_a_boolean :declined

  belongs_to :scheduled_pickup, touch: true
  belongs_to :location, touch: true
  has_one :donor, through: :location, source: :user

  validates :location, presence: true
  validates :scheduled_pickup,
    presence: true,
    uniqueness: { scope: :location_id }

  delegate(:notes, to: :location)

  def self.current
    joins(:scheduled_pickup).merge(ScheduledPickup.current)
  end

  def pickup_date
    scheduled_pickup.start_at.to_date
  end

  def pending?
    ! (confirmed || declined)
  end
end
