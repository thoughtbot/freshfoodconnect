class PreRegistration
  include ActiveModel::Model

  attr_accessor :zipcode

  validates :zipcode, presence: true, zipcode: { country_code: :us }

  def supported?
    DeliveryZone.supported?(zipcode)
  end

  private

  def location
    Location.new(zipcode: zipcode)
  end
end
