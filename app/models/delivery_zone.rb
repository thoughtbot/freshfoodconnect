class DeliveryZone < ActiveRecord::Base
  validates :zipcode,
    presence: true,
    uniqueness: { case_sensitive: false },
    zipcode: { country_code: :us }

  has_many :locations, foreign_key: :zipcode, primary_key: :zipcode
  has_many :users, through: :locations

  def self.supported?(zipcode)
    where(zipcode: zipcode).any?
  end

  def to_param
    zipcode
  end
end
