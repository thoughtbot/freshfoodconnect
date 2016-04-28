module DonationsHelper
  def status_for_donation(donation)
    if donation.picked_up?
      :picked_up
    elsif donation.pending?
      :pending
    elsif donation.confirmed?
      :confirmed
    elsif donation.declined?
      :declined
    else
      :pending
    end
  end

  def status_for_pickup(donation)
    if donation.picked_up?
      :success
    elsif donation.declined?
      :no_donation
    elsif donation.confirmed?
      :confirmed
    else
      :pending
    end
  end

  def label_for_donation(donation)
    t("donations.statuses.#{status_for_donation(donation)}")
  end

  def label_for_pickup(donation)
    t("pickups.statuses.#{status_for_pickup(donation)}")
  end

  def render_donation_status(donation, &block)
    render(layout: "donations/status", locals: { donation: donation }, &block)
  end
end
