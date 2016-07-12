require "rails_helper"

describe "DonorsHelper" do
  describe "#on_site?" do
    it "returns affirmative wording if the location grown_on_site is true" do
      location = create(:location, grown_on_site: true)
      donor = create(:donor, location: location)

      expect(helper.on_site?(donor)).to eq(t("donors.show.grown_on_site"))
    end

    it "returns negative wording if the location grown_on_site is false" do
      location = create(:location, grown_on_site: false)
      donor = create(:donor, location: location)

      expect(helper.on_site?(donor)).to eq(t(".donors.show.grown_off_site"))
    end
  end
end
