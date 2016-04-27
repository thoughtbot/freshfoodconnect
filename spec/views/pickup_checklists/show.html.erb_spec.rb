require "rails_helper"

describe "pickup_checklists/show" do
  it "lists all donations" do
    start_at = Date.new(2016, 4, 14).beginning_of_day
    scheduled_pickup = create(
      :scheduled_pickup,
      start_at: start_at,
      end_at: start_at + 1.hour,
    )
    donation = create(:donation, :confirmed, scheduled_pickup: scheduled_pickup)
    pickup_checklist = PickupChecklist.new(scheduled_pickup)
    assign(:pickup_checklist, pickup_checklist)

    render

    expect(rendered).to have_text("4/14/2016")
    expect(rendered).to have_text(donation.donor.name)
    expect(rendered).to have_address_for(donation)
  end

  def have_address_for(donation)
    have_css("address", text: donation.address)
  end
end
