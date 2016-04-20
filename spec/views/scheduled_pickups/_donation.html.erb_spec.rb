require "rails_helper"

describe "scheduled_pickups/donation" do
  it "displays Donation information" do
    donation = build(:donation, :confirmed)
    donor = donation.donor

    render("scheduled_pickups/donation", donation: donation)

    expect(rendered).to have_text(donor.name)
    expect(rendered).to have_donation_status_text(:confirmed)
  end
end
