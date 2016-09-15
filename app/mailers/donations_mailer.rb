class DonationsMailer < ApplicationMailer
  def request_confirmation(donation:)
    @confirmation = Confirmation.new(donation)

    admins = donation.zone.admins
    reply_to = admins.map(&:email).reject(&:blank?).join(",")

    mail(
      to: donation.donor.email,
      subject: t(".subject", range: @confirmation.time_range),
      "Reply-To" => reply_to.presence || "info@freshfoodconnect.org",
    )
  end
end
