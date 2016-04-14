require "rails_helper"

describe PickupChecklist do
  describe "#donations" do
    it "chains the `confirmed` scope" do
      donation = double
      confirmed_donations = double(confirmed: [donation])
      scheduled_pickup = double(ScheduledPickup, donations: confirmed_donations)
      pickup_checklist = PickupChecklist.new(scheduled_pickup)

      donations = pickup_checklist.donations

      expect(donations).to eq([donation])
    end
  end
end
