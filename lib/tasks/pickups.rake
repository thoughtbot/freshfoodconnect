namespace :pickups do
  desc "Schedule upcoming pickups"
  task schedule: :environment do
    Zone.all.each do |zone|
      PickupScheduler.new(zone).schedule!
    end
  end
end
