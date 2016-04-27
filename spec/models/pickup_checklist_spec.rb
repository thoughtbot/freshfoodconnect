require "rails_helper"

describe PickupChecklist do
  describe "#donations" do
    it "chains the `confirmed` scope" do
      create(:donation, :declined)
      donation = create(:donation, :confirmed)
      pickup_checklist = PickupChecklist.new(donation.scheduled_pickup)

      donations = pickup_checklist.donations

      expect(donations).to eq([donation])
    end

    it "sorts by `created_at`" do
      scheduled_pickup = create(:scheduled_pickup)
      create_donation(scheduled_pickup, name: "third", created_at: 1.day.ago)
      create_donation(scheduled_pickup, name: "first", created_at: 3.days.ago)
      create_donation(scheduled_pickup, name: "second", created_at: 2.days.ago)
      pickup_checklist = PickupChecklist.new(scheduled_pickup)

      donor_names = pickup_checklist.donations.map(&:donor).map(&:name)

      expect(donor_names).to eq(%w[first second third])
    end
  end

  def create_donation(scheduled_pickup, name:, created_at:)
    donor = create(:donor, name: name)

    create(
      :donation,
      :confirmed,
      donor: donor,
      scheduled_pickup: scheduled_pickup,
      created_at: created_at,
    )
  end
end
