class DonationMailer < ActionMailer::Base
  include ScheduledPickupsHelper

  helper ScheduledPickupsHelper

  def remind(donation:)
    @donation = donation
    subject = t(
      ".subject",
      range: format_pickup_time(@donation.scheduled_pickup),
    )

    mail(
      to: donation.donor.email,
      from: "support@freshfoodconnect.org",
      subject: subject,
    )
  end
end
