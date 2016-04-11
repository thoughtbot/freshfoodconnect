namespace :confirmations do
  desc "Send donation confirmation requests"
  task request: :environment do
    Donation.scheduled_for_pick_up_within(hours: 48).pending.each do |donation|
      Confirmation.new(donation).request!
    end
  end
end
