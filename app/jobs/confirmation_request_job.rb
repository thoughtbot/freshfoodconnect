class ConfirmationRequestJob < ActiveJob::Base
  def perform(donation:)
    if donation.unrequested?
      DonationsMailer.request_confirmation(donation: donation).deliver_now
      donation.update!(requested: true)
    end
  end
end
