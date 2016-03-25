RSpec.configure do |config|
  config.before(:each) do
    Geocoder.configure(lookup: :test)
    Geocoder::Lookup::Test.set_default_stub([])
  end
end
