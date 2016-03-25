class GeocodeJob < ActiveJob::Base
  def perform(location)
    address = [location.address, location.zipcode].join(" ")

    latitude, longitude = Geocoder.coordinates(address)

    location.update!(latitude: latitude, longitude: longitude)
  end
end
