class ScheduledPickup < ActiveRecord::Base
  belongs_to :zone

  validates :zone, presence: true
  validates :end_at, presence: true
  validates :start_at, presence: true

  delegate :zipcode, to: :zone

  def self.current
    where("start_at >= ?", Time.current.beginning_of_day)
  end

  def time_range
    TimeRange.new(start_at: start_at, end_at: end_at)
  end

  def users
    []
  end
end
