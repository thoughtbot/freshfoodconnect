require "rails_helper"

describe Donation do
  it { should belong_to(:scheduled_pickup).touch }
  it { should belong_to(:location).touch }
  it { should have_one(:donor).through(:location) }
  it { should have_one(:zone).through(:scheduled_pickup) }

  it { should define_enum_for(:size).with(%i[small medium large]) }

  it { should validate_presence_of(:scheduled_pickup) }
  it { should validate_presence_of(:location) }

  it { should delegate_method(:address).to(:location) }
  it { should delegate_method(:geocoded?).to(:location) }
  it { should delegate_method(:latitude).to(:location) }
  it { should delegate_method(:longitude).to(:location) }
  it { should delegate_method(:date).to(:scheduled_pickup) }
  it { should delegate_method(:time_range).to(:scheduled_pickup) }

  context "uniqueness" do
    subject { create(:donation) }

    it do
      should validate_uniqueness_of(:scheduled_pickup).scoped_to(:location_id)
    end
  end

  describe ".confirmed" do
    it "includes confirmed donations" do
      confirmed_donation = create(:donation, :confirmed)
      reconfirmed_donation = create(:donation, :declined_then_confirmed)
      create(:donation, :confirmed_then_declined)
      create(:donation, :declined)
      create(:donation, :pending)

      confirmed = Donation.confirmed
      donors = confirmed.map(&:donor)

      expect(donors.map(&:name)).to eq([
        confirmed_donation.donor.name,
        reconfirmed_donation.donor.name,
      ])
    end
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

  describe ".pending" do
    it "includes Donations that have not yet been confirmed or declined" do
      pending = create(:donation, :pending)
      create(:donation, :confirmed)
      create(:donation, :declined)
      create(:donation, :confirmed, :declined)

      results = Donation.pending

      expect(results).to eq([pending])
    end
  end

  describe ".scheduled_for_pick_up_within" do
    it "includes donations to be picked the number of hours in the future" do
      thursday = Date.new(2016, 9, 15).beginning_of_day
      wednesday = thursday - 1.hour
      saturday = Date.new(2016, 9, 17).beginning_of_day + 8.hours
      sunday = Date.new(2016, 9, 18).beginning_of_day

      Timecop.freeze(thursday) do
        past_pickup = schedule_pickup(starting: wednesday)
        current_pickup = schedule_pickup(starting: saturday)
        future_pickup = schedule_pickup(starting: sunday)
        create(:donation, scheduled_pickup: past_pickup)
        create(:donation, scheduled_pickup: future_pickup)
        create(:donation, scheduled_pickup: current_pickup)

        results = Donation.scheduled_for_pick_up_within(hours: 48)
        pickup_times = results.map(&:scheduled_pickup).map(&:start_at)

        expect(pickup_times).to eq([saturday])
      end
    end

    def schedule_pickup(starting:)
      create(:scheduled_pickup, start_at: starting, end_at: starting + 1.hour)
    end

    around do |example|
      Timecop.freeze { example.run }
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
