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

  describe "#current_scheduled_pickup", :rake do
    it "returns the current ScheduledPickup" do
      delivery_zone = create(
        :delivery_zone,
        :with_scheduled_pickups,
        start_hour: 0,
        end_hour: 1,
        weekday: 0,
      )

      current_scheduled_pickup = delivery_zone.current_scheduled_pickup

      expect(current_scheduled_pickup.start_at.hour).to eq(0)
      expect(current_scheduled_pickup.end_at.hour).to eq(1)
      expect(current_scheduled_pickup.start_at.wday).to eq(0)
    end
  end
end
