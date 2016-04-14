namespace :confirmations do
  desc "Send donation confirmation requests"
  task request: :environment do
    hours = ScheduledPickup::HOURS_IN_ADVANCE_FOR_CONFIRMATION

    Donation.
      scheduled_for_pick_up_within(hours: hours).
      pending.
      each do |donation|
      Confirmation.new(donation).request!
    end
  end
end
