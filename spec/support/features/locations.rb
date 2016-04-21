module Features
  def stub_geocoding_for(address, latitude:, longitude:)
    Geocoder::Lookup::Test.add_stub(
      address, [{
        "latitude" => latitude,
        "longitude" => longitude,
      }],
    )
  end
end
