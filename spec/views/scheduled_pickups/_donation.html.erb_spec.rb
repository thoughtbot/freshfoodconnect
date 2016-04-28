require "rails_helper"

describe "scheduled_pickups/donation" do
  it "displays Donation information" do
    donation = build(:donation, :confirmed)
    donor = donation.donor

    render("scheduled_pickups/donation", donation: donation)

    expect(rendered).to have_text(donor.name)
    expect(rendered).to have_pickup_status_text(:confirmed)
  end

  context "when the Donation is pending" do
    it "is displayed as 'Unconfirmed'" do
      donation = build(:donation, :pending)

      render("scheduled_pickups/donation", donation: donation)

      expect(rendered).to have_pickup_status_text(:pending)
    end
  end

  def have_pickup_status_text(status)
    have_text t("pickups.statuses.#{status}")
  end
end
