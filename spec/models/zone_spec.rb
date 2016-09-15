require "rails_helper"

describe Zone do
  it { should validate_presence_of(:start_hour) }
  it { should validate_presence_of(:end_hour) }
  it { should validate_presence_of(:weekday) }
  it { should validate_presence_of(:zipcode) }

  it { should validate_numericality_of(:end_hour).is_less_than_or_equal_to(Hour.count) }
  it { should validate_numericality_of(:end_hour).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:end_hour).only_integer }
  it { should validate_numericality_of(:start_hour).is_less_than_or_equal_to(Hour.count) }
  it { should validate_numericality_of(:start_hour).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:start_hour).only_integer }
  it { should validate_inclusion_of(:weekday).in_array(Weekday.all.map(&:value)) }

  it { should have_many(:locations) }
  it { should have_many(:scheduled_pickups) }
  it { should have_many(:admins).through(:region) }
  it { should have_many(:users).through(:locations) }
  it { should belong_to(:region) }

  context "uniqueness" do
    subject { build(:zone) }

    it { should validate_uniqueness_of(:zipcode).case_insensitive }
  end

  describe "#current_scheduled_pickup", :rake do
    it "returns the current ScheduledPickup" do
      zone = create(
        :zone,
        :with_scheduled_pickups,
        start_hour: 0,
        end_hour: 1,
        weekday: 0,
      )

      current_scheduled_pickup = zone.current_scheduled_pickup

      expect(current_scheduled_pickup.start_at.hour).to eq(0)
      expect(current_scheduled_pickup.end_at.hour).to eq(1)
      expect(current_scheduled_pickup.start_at.wday).to eq(0)
    end
  end
end
