class User < ActiveRecord::Base
  SUPPORTED_ZIPCODES = %w[80221].freeze

  include Clearance::User

  has_one :location, dependent: :destroy

  validates :email, presence: true
  validates :password, presence: true
  validates :zipcode, presence: true

  def supported?
    SUPPORTED_ZIPCODES.include?(zipcode)
  end

  def zipcode=(zipcode)
    super(zipcode.to_s.strip)
  end
end
