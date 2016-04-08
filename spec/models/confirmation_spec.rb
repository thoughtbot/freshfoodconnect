require "rails_helper"

describe Confirmation do
  describe "#confirm!" do
    it "confirms the donation" do
      donation = build(:donation, confirmed: nil)
      confirmation = Confirmation.new(donation: donation)

      confirmation.confirm!

      expect(donation).to be_confirmed
    end
  end

  describe "#decline!" do
    it "declines the donation" do
      donation = build(:donation, declined: nil)
      confirmation = Confirmation.new(donation: donation)

      confirmation.decline!

      expect(donation).to be_declined
    end
  end
end
