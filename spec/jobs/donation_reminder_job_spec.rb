require "rails_helper"

describe DonationReminderJob do
  describe "#perform" do
    context "when the Donation is confirmed" do
      it "sets the reminded flag on the Donation" do
        donation = create(:donation, :confirmed)
        DonationReminderJob.perform_now(donation: donation)

        reminded = donation.reminded

        expect(reminded).to be true
      end
    end

    context "when the Donation is declined" do
      it "does not set the reminded flag on the Donation" do
        donation = create(:donation, :declined)
        DonationReminderJob.perform_now(donation: donation)

        reminded = donation.reminded

        expect(reminded).to be false
      end
    end
  end
end
