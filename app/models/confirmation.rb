class Confirmation
  def initialize(donation:)
    @donation = donation
  end

  def confirm!
    donation.update!(confirmed: true)
    schedule_notification_email!
  end

  def decline!
    donation.update!(declined: true)
  end

  attr_reader :donation

  private

  def schedule_notification_email!
    DonationReminderJob.
      set(wait_until: donation.remind_donor_at)
      .perform_later(donation: donation)
  end
end
