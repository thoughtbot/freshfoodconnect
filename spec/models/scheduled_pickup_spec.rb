require "rails_helper"

describe ScheduledPickup do
  it { should belong_to(:delivery_zone) }

  it { should validate_presence_of(:delivery_zone) }
  it { should validate_presence_of(:end_at) }
  it { should validate_presence_of(:start_at) }

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
end
