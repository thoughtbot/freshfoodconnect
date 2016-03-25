require "rails_helper"

describe User do
  it { should have_one(:location).dependent(:destroy) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:zipcode) }

  describe "#zipcode=" do
    it "strips whitespace" do
      user = User.new

      user.zipcode = "     90210 "

      expect(user.zipcode).to eq("90210")
    end
  end

  describe "#supported?" do
    context "when the zipcode is included in SUPPORTED_ZIPCODES" do
      it "returns true" do
        zipcode = User::SUPPORTED_ZIPCODES.first
        user = build(:user, zipcode: zipcode)

        supported = user.supported?

        expect(supported).to be true
      end
    end

    context "when the zipcode isn't included in SUPPORTED_ZIPCODES" do
      it "returns false" do
        user = build(:user, zipcode: "90210")

        supported = user.supported?

        expect(supported).to be false
      end
    end
  end
end
