require "rails_helper"

describe PickupScheduler do
  context "when there are no pickups scheduled for the current week" do
    it "creates a ScheduledPickup" do
      friday = thursday + 1.day
      last_friday = friday - 1.week

      Timecop.freeze(thursday) do
        zone = create(
          :zone,
          start_hour: 0,
          end_hour: 1,
          weekday: friday.wday,
        )
        create(
          :scheduled_pickup,
          zone: zone,
          start_at: last_friday,
          end_at: last_friday,
        )
        scheduler = PickupScheduler.new(zone)

        scheduler.schedule!
        pickup = ScheduledPickup.last

        expect(ScheduledPickup.count).to eq(2)
        expect(pickup.start_at).to be_scheduled_for(friday, at: zone.start_hour)
        expect(pickup.end_at.hour).to eq(zone.end_hour)
      end
    end
  end

  context "when there is already a Pickup scheduled for the week" do
    it "doesn't create a ScheduledPickup" do
      friday = thursday + 1.day
      saturday = thursday + 2.days

      Timecop.freeze(thursday) do
        zone = create(:zone, weekday: friday.wday)
        create(
          :scheduled_pickup,
          zone: zone,
          start_at: saturday,
          end_at: saturday,
        )
        scheduler = PickupScheduler.new(zone)

        scheduler.schedule!

        expect(ScheduledPickup.count).to eq(1)
      end
    end

    it "creates Donations for the week" do
      Timecop.freeze(thursday) do
        scheduled_pickup = create(:scheduled_pickup)
        zone = scheduled_pickup.zone
        location = create(:location, zipcode: zone.zipcode)
        scheduler = PickupScheduler.new(zone)

        scheduler.schedule!

        expect(location.donations.last).to have_attributes(
          scheduled_pickup: scheduled_pickup,
        )
      end
    end
  end

  it "enrolls Donors in the Zone" do
    zone = create(:zone, :unscheduled)
    location = create(:location, zone: zone)
    scheduler = PickupScheduler.new(zone)

    scheduler.schedule!

    expect(Donation.count).to eq(1)
    expect(Donation.all.map(&:donor)).to eq([location.user])
  end

  def be_scheduled_for(date, at:)
    have_attributes(
      day: date.day,
      hour: at,
      month: date.month,
      wday: date.wday,
      year: date.year,
    )
  end

  def thursday
    Date.new(2016, 4, 14).beginning_of_day
  end
end
