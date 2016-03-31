class Location < ActiveRecord::Base
  SUPPORTED_ZIPCODES = %w[80221].freeze

  belongs_to :user, touch: true

  validates :address, presence: true
  validates :user, presence: true
  validates :zipcode, presence: true

  def supported?
    SUPPORTED_ZIPCODES.include?(zipcode)
  end

  def zipcode=(zipcode)
    super(zipcode.to_s.strip)
  end
end
