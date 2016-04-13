module DonationsHelper
  def status_for_donation(donation)
    if donation.pending?
      :pending
    elsif donation.confirmed?
      :confirmed
    elsif donation.declined?
      :declined
    end
  end

  def label_for_donation(donation)
    t("donations.statuses.#{status_for_donation(donation)}")
  end

  def render_donation_status(donation, &block)
    render(layout: "donations/status", locals: { donation: donation }, &block)
  end
end
