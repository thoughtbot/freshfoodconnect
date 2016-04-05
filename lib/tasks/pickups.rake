namespace :pickups do
  desc "Schedule upcoming pickups"
  task schedule: :environment do
    DeliveryZone.all.each do |delivery_zone|
      delivery_zone.schedule_pickups.create!(
        start_at: start_at,
        end_at: end_at,
      )
    end
  end
end
