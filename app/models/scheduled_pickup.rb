class ScheduledPickup < ActiveRecord::Base
  belongs_to :delivery_zone

  validates :delivery_zone, presence: true
  validates :scheduled_for, presence: true
  validates :time_range, presence: true

  def self.current
    where("scheduled_for >= ?", Time.current.beginning_of_day)
  end
end
