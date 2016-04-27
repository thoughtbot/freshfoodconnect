class Location < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :zone, foreign_key: :zipcode, primary_key: :zipcode

  has_many :donations, dependent: :destroy

  enum location_type: {
    residence: 0,
    community_garden: 1,
    business: 2,
    other: 3,
  }

  validates :address, presence: true
  validates :latitude, numericality: {
    greater_than_or_equal_to: -90,
    less_than_or_equal_to: 90,
    allow_nil: true,
  }
  validates :longitude, numericality: {
    greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180,
    allow_nil: true,
  }
  validates :location_type, presence: true
  validates :user, presence: true
  validates :zipcode, presence: true, zipcode: { country_code: :us }
  validate :zipcode_is_supported

  def self.not_geocoded
    where("latitude IS NULL OR longitude IS NULL")
  end

  def geocoded?
    latitude.present? && longitude.present?
  end

  def zipcode=(zipcode)
    super(zipcode.to_s.strip)
  end

  private

  def zipcode_is_supported
    unless Zone.supported?(zipcode)
      errors[:zipcode] = I18n.t(
        "validations.locations.unsupported",
        zipcode: zipcode,
      )
    end
  end
end
