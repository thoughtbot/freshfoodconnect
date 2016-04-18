class GoogleMap
  include ActiveModel::Conversion

  attr_reader :id

  def initialize(donations:, callback:, id:)
    @callback = callback
    @donations = donations
    @id = id
  end

  def empty?
    markers.empty?
  end

  def center
    lat, lng = Geocoder::Calculations.geographic_center(coordinates)

    { lat: lat, lng: lng }
  end

  def markers
    donations.map do |donation|
      {
        lat: donation.latitude.to_f,
        lng: donation.longitude.to_f,
      }
    end
  end

  def src_url
    "https://maps.googleapis.com/maps/api/js?#{params.to_param}"
  end

  def donations
    @donations.select(&:geocoded?)
  end

  private

  attr_reader :callback

  def coordinates
    markers.map do |marker|
      [
        marker[:lat],
        marker[:lng],
      ]
    end
  end

  def params
    {
      callback: callback,
      key: ENV.fetch("GOOGLE_MAPS_API_KEY"),
    }
  end
end
