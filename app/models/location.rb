class Location < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :delivery_zone, foreign_key: :zipcode, primary_key: :zipcode

  validates :address, presence: true
  validates :delivery_zone, presence: true
  validates :user, presence: true
  validates :zipcode, presence: true, zipcode: { country_code: :us }

  def zipcode=(zipcode)
    super(zipcode.to_s.strip)
  end
end
