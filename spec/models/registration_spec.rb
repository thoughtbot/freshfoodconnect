require "rails_helper"

describe Registration do
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:zipcode) }

  it do
    should validate_presence_of(:organic_growth_asserted).
      with_message(t("validations.accepted"))
  end
  it do
    should validate_presence_of(:terms_and_conditions_accepted).
      with_message(t("validations.accepted"))
  end

  describe "#save!" do
    context "when invalid" do
      it "raises an ActiveRecord::InvalidRecordError" do
        registration = Registration.new

        expect { registration.save! }.
          to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "#save" do
    context "when valid" do
      it "creates a User with a Location" do
        location = build(:location, :supported, :residence)
        registration = build(:registration, zipcode: location.zipcode)

        saved = registration.save
        user = registration.user
        location = registration.location

        expect(saved).to be true
        expect(registration).to have_attributes(
          invalid?: false,
          valid?: true,
        )
        expect(user).to have_attributes(
          email: registration.email,
          location: location,
          name: registration.name,
          persisted?: true,
          terms_and_conditions_accepted: true,
          valid?: true,
        )
        expect(location).to have_attributes(
          address: registration.address,
          grown_on_site?: true,
          location_type: "residence",
          persisted?: true,
          user: user,
          valid?: true,
          zipcode: registration.zipcode,
        )
      end

      context "when the Zone can accept donors" do
        it "creates a Donation for their Zone's current scheduled pickup" do
          zone = create(:zone, :with_scheduled_pickups)
          registration = build(:registration, zipcode: zone.zipcode)

          saved = registration.save
          user = registration.user
          current_donation = user.current_donation

          expect(saved).to be true
          expect(current_donation).to have_attributes(
            confirmed?: false,
            declined?: false,
            invalid?: false,
            pending?: true,
            persisted?: true,
            valid?: true,
          )
        end
      end

      context "when the Zone can't accept donors" do
        it "returns true" do
          zone = create(:zone, :unscheduled)
          registration = build(:registration, zipcode: zone.zipcode)

          saved = registration.save

          expect(saved).to be true
        end
      end

      context "when invalid" do
        it "exposes validation errors" do
          registration = Registration.new

          registration.save

          expect(registration).to have_attributes(
            valid?: false,
            invalid?: true,
          )
          expect(registration.user).to have_attributes(
            persisted?: false,
            valid?: false,
          )
          expect(registration.location).to have_attributes(
            persisted?: false,
            valid?: false,
          )
        end
      end
    end
  end
end
