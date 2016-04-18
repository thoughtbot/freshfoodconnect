class ScheduledPickup < ActiveRecord::Base
  HOURS_IN_ADVANCE_FOR_CONFIRMATION = 48

  belongs_to :zone, touch: true

  has_many :donations, dependent: :destroy

  validates :zone, presence: true
  validates :end_at, presence: true
  validates :start_at, presence: true

  def self.current
    where("start_at >= ?", Time.current.beginning_of_day)
  end

  def build_google_map(callback:, id:)
    GoogleMap.new(
      callback: callback,
      donations: donations.confirmed,
      id: id,
    )
  end

  def date
    start_at.to_date
  end

  def time_range
    TimeRange.new(start_at: start_at, end_at: end_at)
  end

  def confirmation_requested_at
    start_at - HOURS_IN_ADVANCE_FOR_CONFIRMATION.hours
  end

  def users
    []
  end
end
