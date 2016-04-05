class DeliveryZone < ActiveRecord::Base
  validates :zipcode,
    presence: true,
    uniqueness: { case_sensitive: false },
    zipcode: { country_code: :us }

  has_many :locations, foreign_key: :zipcode, primary_key: :zipcode
  has_many :scheduled_pickups
  has_many :users, through: :locations

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
