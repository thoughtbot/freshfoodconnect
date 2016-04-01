require "rails_helper"

describe Location do
  it { should belong_to(:user).touch(true) }
  it { should belong_to(:delivery_zone) }

  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:delivery_zone) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:zipcode) }

  describe "#zipcode=" do
    it "trims whitespace" do
      location = Location.new(zipcode: "    90210 ")

      zipcode = location.zipcode

      expect(zipcode).to eq("90210")
    end
  end
end
