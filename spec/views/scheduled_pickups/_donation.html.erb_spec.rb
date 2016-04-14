require "rails_helper"

describe "scheduled_pickups/donation" do
  it "displays Donation information" do
    donation = build(:donation, :confirmed)
    donor = donation.donor

    render("scheduled_pickups/donation", donation: donation)

    expect(rendered).to have_text(donor.name)
    expect(rendered).to have_status_text(:confirmed)
  end

  def have_status_text(status)
    have_text t("donations.statuses.#{status}")
  end
end
