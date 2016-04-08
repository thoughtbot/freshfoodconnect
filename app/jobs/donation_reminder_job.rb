class DonationReminderJob < ActiveJob::Base
  queue_as :default

  def perform(donation:)
    if donation.confirmed?
      DonationMailer.remind(donation: donation).deliver_now
      donation.update!(reminded: true)
    end
  end
end
