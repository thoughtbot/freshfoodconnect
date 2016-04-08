require "rails_helper"

describe Donation do
  it { should belong_to(:scheduled_pickup).touch }
  it { should belong_to(:location).touch }
  it { should have_one(:donor).through(:location) }

  it { should define_enum_for(:size).with(%i[small medium large]) }

  it { should validate_presence_of(:scheduled_pickup) }
  it { should validate_presence_of(:location) }

  it { should delegate_method(:address).to(:location) }
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

  describe "#confirmed?" do
    context "when confirmed_at is falsy" do
      it "returns false" do
        donation = Donation.new(confirmed_at: nil)

        confirmed = donation.confirmed?

        expect(confirmed).to be false
      end
    end

    context "when the Donation has been confirmed" do
      context "and not yet declined" do
        it "returns true" do
          donation = Donation.new(declined_at: nil, confirmed: true)

          confirmed = donation.confirmed?

          expect(confirmed).to be true
        end
      end

      context "and then declined" do
        it "returns false" do
          donation = Donation.new(
            confirmed_at: 1.minute.ago,
            declined_at: Time.current,
          )

          confirmed = donation.confirmed?

          expect(confirmed).to be false
        end
      end

      context "after being previously declined" do
        it "returns true" do
          donation = Donation.new(
            declined_at: 1.minute.ago,
            confirmed_at: Time.current,
          )

          confirmed = donation.confirmed?

          expect(confirmed).to be true
        end
      end
    end
  end

  describe "#declined?" do
    context "when declined_at is falsy" do
      it "returns false" do
        donation = Donation.new(declined_at: nil)

        declined = donation.declined?

        expect(declined).to be false
      end
    end

    context "when the Donation has been declined" do
      context "and not yet confirmed" do
        it "returns true" do
          donation = Donation.new(confirmed_at: nil, declined: true)

          declined = donation.declined?

          expect(declined).to be true
        end
      end

      context "and then confirmed" do
        it "returns false" do
          donation = Donation.new(
            declined_at: 1.minute.ago,
            confirmed_at: Time.current,
          )

          declined = donation.declined?

          expect(declined).to be false
        end
      end

      context "after being previously confirmed" do
        it "returns true" do
          donation = Donation.new(
            confirmed_at: 1.minute.ago,
            declined_at: Time.current,
          )

          declined = donation.declined?

          expect(declined).to be true
        end
      end
    end
  end

  describe "#remind_donor_at" do
    it "is 48 hours before the earliest pickup time" do
      pickup_time = Time.current
      scheduled_pickup = create(:scheduled_pickup, start_at: pickup_time)
      donation = create(:donation, scheduled_pickup: scheduled_pickup)

      remind_donor_at = donation.remind_donor_at

      expect(remind_donor_at).to eq(pickup_time - 48.hours)
    end

    around do |example|
      Timecop.freeze { example.run }
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
