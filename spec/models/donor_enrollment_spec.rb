require "rails_helper"

describe DonorEnrollment do
  context "when the Zone has a currently scheduled pickup" do
    context "and the donor has not been enrolled" do
      it "creates a donation" do
        zone = create(:zone, :with_scheduled_pickups)
        location = create(:location, zone: zone)
        donor = location.user
        donor_enrollment = DonorEnrollment.new(location: location)

        donor_enrollment.save!

        expect(donor_enrollment.donation).to have_attributes(
          invalid?: false,
          valid?: true,
          persisted?: true,
        )
        expect(donor.current_donation).to eq(donor_enrollment.donation)
      end
    end

    context "and the donor is already enrolled" do
      it "does not create another donation" do
        zone = create(:zone, :with_scheduled_pickups)
        location = create(:location, zone: zone)
        donor = location.user
        scheduled_pickup = zone.current_scheduled_pickup
        create(:donation, scheduled_pickup: scheduled_pickup, location: location)
        donor_enrollment = DonorEnrollment.new(location: location)

        donor_enrollment.save!

        expect(Donation.count).to eq(1)
        expect(donor.current_donation).to eq(donor_enrollment.donation)
      end
    end
  end

  context "when a pickup isn't currently scheduled for the Zone" do
    it "does not create a donation" do
      zone = create(:zone, :unscheduled)
      location = create(:location, zone: zone)
      donor = location.user
      donor_enrollment = DonorEnrollment.new(location: location)

      donor_enrollment.save!

      expect(Donation.count).to eq(0)
      expect(donor_enrollment.donation).to have_attributes(
        invalid?: true,
        valid?: false,
        persisted?: false,
      )
      expect(donor.current_donation).to be nil
    end
  end
end
