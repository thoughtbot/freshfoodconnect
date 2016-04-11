class DonationsPreview < ActionMailer::Preview
  def request_confirmation
    DonationsMailer.request_confirmation(donation: Donation.last)
  end
end
