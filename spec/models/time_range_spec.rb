require "spec_helper"

describe TimeRange do
  describe "#to_s" do
    it "formats the date information" do
      wednesday = Date.new(2016, 4, 13)
      start_at = wednesday.beginning_of_day
      end_at = start_at + 1.hour
      time_range = TimeRange.new(start_at: start_at, end_at: end_at)
      formatted = time_range.to_s

      expect(formatted).
        to eq("Wednesday April 13, 2016 between 12:00 am and 1:00 am")
    end
  end
end
