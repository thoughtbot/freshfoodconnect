class DonationsMailer < ActionMailer::Base
  def request_confirmation(donation:)
    @confirmation = Confirmation.new(donation)

    mail(
      to: donation.donor.email,
      subject: t(".subject", range: @confirmation.time_range),
      from: "support@freshfoodconnect.com",
    )
  end
end
