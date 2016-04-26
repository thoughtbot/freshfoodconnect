class DonationsMailer < ApplicationMailer
  def request_confirmation(donation:)
    @confirmation = Confirmation.new(donation)

    mail(
      to: donation.donor.email,
      subject: t(".subject", range: @confirmation.time_range),
    )
  end
end
