require "rails_helper"

describe ScheduledPickup do
  it { should belong_to(:delivery_zone) }

  it { should validate_presence_of(:delivery_zone) }
  it { should validate_presence_of(:scheduled_for) }
  it { should validate_presence_of(:time_range) }

  describe ".current" do
    it "includes scheduled pickups from today and onward" do
      today = Time.current
      create(:scheduled_pickup, scheduled_for: today - 1.day, time_range: "at noon")
      create(:scheduled_pickup, scheduled_for: today, time_range: "at midnight")
      create(:scheduled_pickup, scheduled_for: today + 1.day, time_range: "whenever")

      current = ScheduledPickup.current

      expect(current.pluck(:time_range)).to match_array([
        "at midnight",
        "whenever",
      ])
    end

    # around do |example|
    #   Timecop.freeze { example.run }
    # end
  end
end
