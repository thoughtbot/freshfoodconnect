class DonationMailerPreview < ActionMailer::Preview
  def notify
    DonationMailer.remind(donation: Donation.first)
  end
end
