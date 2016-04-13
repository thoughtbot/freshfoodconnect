require "rails_helper"

describe Location do
  it { should have_many(:donations).dependent(:destroy) }
  it { should belong_to(:user).touch(true) }
  it { should belong_to(:zone) }

  it do
    should define_enum_for(:location_type).with(
      residence: 0,
      community_garden: 1,
      business: 2,
      other: 3,
    )
  end

  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:location_type) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:zipcode) }
  it { should validate_presence_of(:zone) }

  describe "#zipcode=" do
    it "trims whitespace" do
      location = Location.new(zipcode: "    90210 ")

      zipcode = location.zipcode

      expect(zipcode).to eq("90210")
    end
  end
end
