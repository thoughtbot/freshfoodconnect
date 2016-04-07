require "rails_helper"

describe Registration do
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:zipcode) }

  describe "validations" do
    context "when a Location has an unsupported zipcode" do
      it "exposes errors for :zipcode" do
        create(:zone, zipcode: "90210")
        registration = build(:registration, zipcode: "00000")

        registration.validate

        expect(registration).to have_attributes(
          valid?: false,
          invalid?: true,
        )
        expect(registration.errors[:zipcode]).
          to eq([t("validations.unsupported", zipcode: registration.zipcode)])
      end
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
          location = build(:location, :supported)
          registration = build(:registration, zipcode: location.zipcode)

          saved = registration.save
          user = registration.user
          location = registration.location

          expect(saved).to be true
          expect(registration).to have_attributes(
            valid?: true,
            invalid?: false,
          )
          expect(user).to have_attributes(
            name: registration.name,
            email: registration.email,
            location: location,
            persisted?: true,
            valid?: true,
          )
          expect(location).to have_attributes(
            address: registration.address,
            user: user,
            zipcode: registration.zipcode,
            persisted?: true,
            valid?: true,
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
