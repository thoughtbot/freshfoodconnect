namespace :pickups do
  desc "Schedule upcoming pickups"
  task schedule: :environment do
    DeliveryZone.all.each do |delivery_zone|
      PickupScheduler.new(delivery_zone).schedule!
    end
  end
end
