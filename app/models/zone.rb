class Zone < ActiveRecord::Base
  validates :end_hour,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: Hour.count,
      only_integer: true,
    }
  validates :start_hour,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: Hour.count,
      only_integer: true,
    }
  validates :weekday,
    presence: true,
    inclusion: { in: Weekday.all.map(&:value) }
  validates :zipcode,
    presence: true,
    uniqueness: { case_sensitive: false },
    zipcode: { country_code: :us }

  has_many :admins, through: :region
  has_many :locations, foreign_key: :zipcode, primary_key: :zipcode
  has_many :scheduled_pickups
  has_many :users, through: :locations
  belongs_to :region

  def self.supported?(zipcode)
    where(zipcode: zipcode).any?
  end

  def current_scheduled_pickup
    scheduled_pickups.current.first
  end

  def to_param
    zipcode
  end
end
