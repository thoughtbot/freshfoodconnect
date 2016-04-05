require "rails_helper"

describe "delivery_zones/show" do
  it "displays the Delivery Zone" do
    current_scheduled_pickup = build_scheduled_pickup(
      start_at: now + 1.hour,
      end_at: now + 2.hours,
    )
    delivery_zone = build_delivery_zone(
      zipcode: "90210",
      current_scheduled_pickup: current_scheduled_pickup,
    )
    assign(:delivery_zone, delivery_zone)

    render

    expect(rendered).to have_text(delivery_zone.zipcode)
    expect(rendered).to have_text("1:00 am")
    expect(rendered).to have_text("2:00 am")
  end

  context "when there isn't a pickup scheduled" do
    it "mentions that there isn't a pickup" do
      delivery_zone = build_delivery_zone
      assign(:delivery_zone, delivery_zone)

      render

      expect(rendered).to have_text(t("delivery_zones.show.no_pickup"))
    end
  end

  def build_scheduled_pickup(**options)
    double(ScheduledPickup, options)
  end

  def build_delivery_zone(**options)
    attributes = attributes_for(:delivery_zone).
      merge(options).
      reverse_merge(
        users: [],
        current_scheduled_pickup: nil,
      )

    double(DeliveryZone, attributes)
  end

  let(:now) { Date.new(2016, 4, 5).beginning_of_day }

  before do
    view.signed_in = true
  end

  around do |example|
    Timecop.freeze(now) { example.run }
  end
end
