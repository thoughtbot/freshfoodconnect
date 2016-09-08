class DonationsMailer < ApplicationMailer
  def request_confirmation(donation:)
    @confirmation = Confirmation.new(donation)

    reply_to = donation&.location&.zone&.region&.admin&.email || "info@freshfoodconnect.org"

    mail(
      to: donation.donor.email,
      subject: t(".subject", range: @confirmation.time_range),
      "Reply-To" => reply_to
    )
  end
end
