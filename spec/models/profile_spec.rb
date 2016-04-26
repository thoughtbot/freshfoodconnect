require "rails_helper"

describe Profile do
  it { should delegate_method(:location).to(:user) }
  it { should delegate_method(:name).to(:user) }

  it { should delegate_method(:address).to(:location) }
  it { should delegate_method(:notes).to(:location) }
  it { should delegate_method(:zipcode).to(:location) }

  describe "#phone_number" do
    it "formats the phone number" do
      user = build_stubbed(:user, phone_number: "+15555555555")
      profile = Profile.new(user: user)

      phone_number = profile.phone_number

      expect(phone_number).to eq("(555)-555-5555")
    end

    context "when the User's phone number is blank" do
      it "is blank" do
        user = build_stubbed(:user, phone_number: nil)
        profile = Profile.new(user: user)

        phone_number = profile.phone_number

        expect(phone_number).to be_blank
      end
    end
  end

  describe "#update" do
    context "when valid" do
      it "updates the Location" do
        location = build(
          :location,
          address: "original",
          zipcode: "90210",
          notes: "original",
        )
        profile = Profile.new(user: location.user)
        updated_attributes = {
          address: "new",
          notes: "new",
          zipcode: "80225",
        }

        profile.update(updated_attributes)

        expect(profile.location).to have_attributes(updated_attributes)
      end

      it "updates the User" do
        donor = build(
          :donor,
          email: "old@example.com",
          name: "old",
        )
        profile = Profile.new(user: donor)
        updated_attributes = {
          email: "new@example.com",
          name: "new",
        }

        profile.update(updated_attributes)

        expect(profile.user).to have_attributes(updated_attributes)
      end
    end

    context "when invalid" do
      it "exposes errors from the Location" do
        location = build_stubbed(:location)
        profile = Profile.new(user: location.user)

        profile.update(address: nil)

        expect(profile.errors).not_to be_empty
      end

      it "exposes errors from the User" do
        donor = build_stubbed(:donor)
        profile = Profile.new(user: donor)

        profile.update(email: nil)

        expect(profile.errors).not_to be_empty
      end
    end
  end
end
