require "rails_helper"

describe Donation do
  it { should belong_to(:scheduled_pickup).touch }
  it { should belong_to(:location).touch }
  it { should have_one(:donor).through(:location) }

  it { should validate_presence_of(:scheduled_pickup) }
  it { should validate_presence_of(:location) }

  it { should delegate_method(:notes).to(:location) }

  context "uniqueness" do
    subject { create(:donation) }

    it { should validate_uniqueness_of(:scheduled_pickup).scoped_to(:location_id) }
  end

  describe ".current" do
    it "returns the current donations" do
      scheduled_pickup = create(:scheduled_pickup, :current)
      past_scheduled_pickup = create(:scheduled_pickup, :past)
      current_donation = create(:donation, scheduled_pickup: scheduled_pickup)
      create(:donation, scheduled_pickup: past_scheduled_pickup)

      current = Donation.current

      expect(current).to eq([current_donation])
    end
  end

  describe "#pending?" do
    context "when the donation has been confirmed" do
      it "returns false" do
        donation = Donation.new(confirmed: true)

        pending = donation.pending?

        expect(pending).to be false
      end
    end

    context "when the donation has been declined" do
      it "returns false" do
        donation = Donation.new(declined: true)

        pending = donation.pending?

        expect(pending).to be false
      end
    end

    context "when the donation has been neither confirmed nor declined" do
      it "returns true" do
        donation = Donation.new(confirmed: false, declined: false)

        pending = donation.pending?

        expect(pending).to be true
      end
    end
  end
end
