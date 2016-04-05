require "rails_helper"

describe DeliveryZone do
  it { should validate_presence_of(:zipcode) }

  it { should have_many(:locations) }
  it { should have_many(:scheduled_pickups) }
  it { should have_many(:users).through(:locations) }

  context "uniqueness" do
    subject { build(:delivery_zone) }

    it { should validate_uniqueness_of(:zipcode).case_insensitive }
  end

  describe "#current_scheduled_pickup" do
    it "returns the current ScheduledPickup" do
      delivery_zone = create(:delivery_zone)
      create(
        :scheduled_pickup,
        delivery_zone: delivery_zone,
        scheduled_for: 1.day.ago,
        time_range: "at midnight",
      )
      create(
        :scheduled_pickup,
        delivery_zone: delivery_zone,
        scheduled_for: 1.day.from_now.ago,
        time_range: "at noon",
      )

      current_scheduled_pickup = delivery_zone.current_scheduled_pickup

      expect(current_scheduled_pickup.time_range).to eq("at noon")
    end
  end
end
