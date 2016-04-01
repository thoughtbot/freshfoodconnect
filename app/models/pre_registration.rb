class PreRegistration
  include ActiveModel::Model

  attr_accessor :zipcode

  validates :zipcode, presence: true

  def supported?
    location.supported?
  end

  private

  def location
    Location.new(zipcode: zipcode)
  end
end
