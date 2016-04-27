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

  it { should validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90) }
  it { should validate_numericality_of(:latitude).is_less_than_or_equal_to(90) }
  it { should validate_numericality_of(:latitude).allow_nil }

  it { should validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180) }
  it { should validate_numericality_of(:longitude).is_less_than_or_equal_to(180) }
  it { should validate_numericality_of(:longitude).allow_nil }

  describe "validations" do
    it "validates the Zone is supported" do
      create(:zone, zipcode: "80205")
      location = build(:location, zipcode: "80204")

      valid = location.valid?

      expect(valid).to be false
      expect(location.errors[:zipcode]).
        to eq([unsupported_zipcode_error("80204")])
    end

    def unsupported_zipcode_error(zipcode)
      t("validations.locations.unsupported", zipcode: zipcode)
    end
  end

  describe ".not_geocoded" do
    it "includes Location records without latitude or longitude values" do
      create(:location, latitude: 1, longitude: 1)
      create(:location, latitude: nil, longitude: 1)
      create(:location, latitude: 1, longitude: nil)
      create(:location, latitude: nil, longitude: nil)

      not_geocoded = Location.not_geocoded
      locations = not_geocoded.map do |location|
        {
          latitude: location.latitude,
          longitude: location.longitude,
        }
      end

      expect(locations).to match_array([
        { latitude: nil, longitude: 1 },
        { latitude: 1, longitude: nil },
        { latitude: nil, longitude: nil },
      ])
    end
  end

  describe "#geocoded?" do
    context "when the latitude and longitude are present" do
      it "returns true" do
        location = Location.new(latitude: 5, longitude: 5)

        geocoded = location.geocoded?

        expect(geocoded).to be true
      end
    end

    context "when the latitude is missing" do
      it "returns false" do
        location = Location.new(latitude: nil, longitude: 5)

        geocoded = location.geocoded?

        expect(geocoded).to be false
      end
    end

    context "when the longitude is missing" do
      it "returns false" do
        location = Location.new(latitude: 5, longitude: nil)

        geocoded = location.geocoded?

        expect(geocoded).to be false
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
