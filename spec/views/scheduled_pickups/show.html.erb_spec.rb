require "rails_helper"

describe "scheduled_pickups/show" do
  it "displays the Scheduled Pickup" do
    zone = build_stubbed(:zone)
    scheduled_pickup = build_stubbed(
      :scheduled_pickup,
      start_at: now + 1.hour,
      end_at: now + 2.hours,
      zone: zone,
    )
    assign(:scheduled_pickup, scheduled_pickup)

    render

    expect(rendered).to have_text(zone.zipcode)
    expect(rendered).to have_text("1:00 am")
    expect(rendered).to have_text("2:00 am")
  end

  let(:now) { Date.new(2016, 4, 5).beginning_of_day }

  before do
    view.signed_in = true
  end

  around do |example|
    Timecop.freeze(now) { example.run }
  end
end
