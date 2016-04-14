require "rails_helper"

describe "pickup_checklists/show" do
  it "lists all donations" do
    date = Date.new(2016, 4, 14).to_time
    donation = create(:donation)
    pickup_checklist = build_pickup_checklist(
      confirmed_donations: [donation],
      start_at: date,
    )
    assign(:pickup_checklist, pickup_checklist)

    render

    expect(rendered).to have_text("4/14/2016")
    expect(rendered).to have_text(donation.donor.name)
    expect(rendered).to have_text(donation.address)
  end

  def build_pickup_checklist(confirmed_donations:, **options)
    zone = build_stubbed(:zone)
    donations = double(confirmed: confirmed_donations)
    attributes = options.reverse_merge(zone: zone, donations: donations)

    scheduled_pickup = double(ScheduledPickup, attributes)

    PickupChecklist.new(scheduled_pickup)
  end
end
