require "rails_helper"

describe GoogleMap do
  describe "#markers" do
    it "contains markers for all donation's" do
      donations = [
        double(geocoded?: true, latitude: "40.0", longitude: "60.0"),
        double(geocoded?: true, latitude: "60.0", longitude: "40.0"),
        double(geocoded?: false),
      ]
      google_map = build_google_map(donations)

      markers = google_map.markers

      expect(markers).to match_array([
        { lat: 40.0, lng: 60.0 },
        { lat: 60.0, lng: 40.0 },
      ])
    end
  end

  describe "#center" do
    it "returns the geodesic center of all donations" do
      donations = [
        double(geocoded?: true, latitude: "-1.0", longitude: "1.0"),
        double(geocoded?: true, latitude: "-1.0", longitude: "-1.0"),
        double(geocoded?: true, latitude: "1.0", longitude: "1.0"),
        double(geocoded?: true, latitude: "1.0", longitude: "-1.0"),
      ]
      google_map = build_google_map(donations)

      center = google_map.center

      expect(center).to eq(lat: 0.0, lng: 0.0)
    end
  end

  def build_google_map(donations)
    GoogleMap.new(
      id: :ignored,
      callback: :ignored,
      donations: donations,
    )
  end
end
