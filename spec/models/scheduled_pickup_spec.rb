require "rails_helper"

describe ScheduledPickup do
  it { should belong_to(:zone).touch }

  it { should have_many(:donations).dependent(:destroy) }

  it { should validate_presence_of(:zone) }
  it { should validate_presence_of(:end_at) }
  it { should validate_presence_of(:start_at) }

  it { should delegate_method(:zipcode).to(:zone) }

  describe ".current" do
    it "includes scheduled pickups from today and onward" do
      _yesterday_at_noon = create_scheduled_pickup(yesterday + 12.hours)
      today_at_noon = create_scheduled_pickup(today + 12.hours)
      tomorrow_at_noon = create_scheduled_pickup(tomorrow + 12.hours)

      current = ScheduledPickup.current

      expect(current).to match_array([today_at_noon, tomorrow_at_noon])
    end

    def create_scheduled_pickup(start_at)
      create(:scheduled_pickup, start_at: start_at, end_at: start_at + 1.hour)
    end

    def today
      Time.current.beginning_of_day
    end

    def tomorrow
      today + 1.day
    end

    def yesterday
      today - 1.day
    end
  end

  describe "#confirmation_requested_at" do
    around do |example|
      Timecop.freeze { example.run }
    end

    it "returns a time 48 in advance of the earliest pickup time" do
      scheduled_pickup = create(:scheduled_pickup, start_at: 48.hours.from_now)

      confirmation_requested_at = scheduled_pickup.confirmation_requested_at

      expect(confirmation_requested_at).to eq(Time.current)
    end
  end

  describe "#time_range" do
    it "constructs a TimeRange from the start and end times" do
      scheduled_pickup = build_stubbed(:scheduled_pickup)
      stubbed_time_range = stub_time_range_for(scheduled_pickup)

      time_range = scheduled_pickup.time_range

      expect(time_range).to be stubbed_time_range
    end

    def stub_time_range_for(pickup)
      time_range = double

      allow(TimeRange).
        to receive(:new).
        with(start_at: pickup.start_at, end_at: pickup.end_at).
        and_return(time_range)

      time_range
    end
  end
end
