require "rails_helper"

describe ScheduledPickup do
  it { should belong_to(:delivery_zone) }

  it { should validate_presence_of(:delivery_zone) }
  it { should validate_presence_of(:end_at) }
  it { should validate_presence_of(:start_at) }

  describe ".current" do
    it "includes scheduled pickups from today and onward" do
      _yesterday_at_noon = create(:scheduled_pickup, start_at: yesterday + 12.hours)
      today_at_noon = create(:scheduled_pickup, start_at: today + 12.hours)
      tomorrow_at_noon = create(:scheduled_pickup, start_at: tomorrow + 12.hours)

      current = ScheduledPickup.current

      expect(current).to match_array([
        today_at_noon,
        tomorrow_at_noon,
      ])
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
