describe UnscheduledDonation do
  describe "#to_partial_path" do
    it "is unscheduled_donations/unscheduled_donation" do
      unscheduled_donation = UnscheduledDonation.new

      partial_path = unscheduled_donation.to_partial_path

      expect(partial_path).to eq("unscheduled_donations/unscheduled_donation")
    end
  end
end
