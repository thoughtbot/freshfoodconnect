require "rails_helper"

describe Registration do
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:zipcode) }

  describe "validations" do
    describe "#supported?" do
      context "when the Location is supported" do
        it "is valid" do
          location = attributes_for(:location, :supported)
          registration = build(:registration, location.slice(:zipcode))

          valid = registration.valid?

          expect(valid).to be true
          expect(registration.errors).to be_empty
        end
      end

      context "when the Location is unsupported" do
        it "is invalid" do
          location = attributes_for(:location, :unsupported)
          registration = build(:registration, location.slice(:zipcode))

          valid = registration.valid?

          expect(valid).to be false
          expect(registration.errors[:zipcode]).not_to be_empty
        end
      end
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
        registration = build(:registration)

        registration.save
        user = registration.user
        location = registration.location

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
