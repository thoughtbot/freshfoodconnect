namespace :locations do
  desc "Geocode all missing locations"
  task geocode: :environment do
    Location.not_geocoded.each do |location|
      GeocodeJob.perform_now(location)
    end
  end
end
