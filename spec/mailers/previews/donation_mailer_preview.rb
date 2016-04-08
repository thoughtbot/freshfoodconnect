class DonationMailerPreview < ActionMailer::Preview
  def remind
    DonationMailer.remind(donation: Donation.first)
  end
end
