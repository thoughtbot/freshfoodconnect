require "rails_helper"

describe Location do
  it { should belong_to(:user).touch(true) }

  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:zipcode) }

  describe "#supported?" do
    context "when their zipcode is supported" do
      it "returns true" do
        location = build(:location, :supported)

        supported = location.supported?

        expect(supported).to be true
      end
    end

    context "when their zipcode is unsupported" do
      it "returns false" do
        location = build(:location, :unsupported)

        supported = location.supported?

        expect(supported).to be false
      end
    end
  end

  describe "#zipcode=" do
    it "trims whitespace" do
      location = Location.new(zipcode: "    90210 ")

      zipcode = location.zipcode

      expect(zipcode).to eq("90210")
    end
  end
end
