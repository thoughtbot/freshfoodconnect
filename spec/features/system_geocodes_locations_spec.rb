require "rails_helper"
require "rake"

feature "System geocodes locations" do
  scenario "with `rake locations:geocode`" do
    existing_coordinates = {
      latitude: 5.0,
      longitude: 6.0,
    }
    new_coordinates = {
      latitude: -1.0,
      longitude: 1.0,
    }
    not_geocoded = create(:location, :supported, :not_geocoded)
    geocoded = create(:location, :geocoded, :supported, existing_coordinates)
    stub_geocode(not_geocoded, with: new_coordinates)
    stub_geocode(geocoded, with: change_coordinates(existing_coordinates))

    geocode_locations!

    expect(not_geocoded.reload).to be_geocoded_with(new_coordinates)
    expect(geocoded.reload).to be_geocoded_with(existing_coordinates)
  end

  def stub_geocode(location, with:)
    stub_geocoding_for([location.address, location.zipcode].join(" "), with)
  end

  def change_coordinates(coordinates)
    {
      latitude: coordinates[:latitude] + 1.0,
      longitude: coordinates[:longitude] + 1.0,
    }
  end

  def be_geocoded_with(coordinates)
    have_attributes(coordinates.transform_values { |l| BigDecimal.new(l.to_s) })
  end

  def geocode_locations!
    Rake::Task["locations:geocode"].invoke
  end

  before :all do
    Rake.application.rake_require "tasks/locations"
    Rake::Task.define_task(:environment)
  end
end
