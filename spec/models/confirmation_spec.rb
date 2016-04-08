require "rails_helper"

describe Confirmation do
  include ActiveJob::TestHelper

  describe "#confirm!" do
    it "confirms the donation" do
      donation = build(:donation, confirmed: nil)
      confirmation = Confirmation.new(donation: donation)

      confirmation.confirm!

      expect(donation).to be_confirmed
    end

    it "notifies the Donor 48 hours in advance" do
      donation = create(:donation, :pending, reminded: false)
      confirmation = Confirmation.new(donation: donation)

      perform_enqueued_jobs do
        confirmation.confirm!

        expect(email_queue.count).to eq(1)
      end

      expect(donation.reload).to be_reminded
    end
  end

  describe "#decline!" do
    it "declines the donation" do
      donation = build(:donation, declined: nil)
      confirmation = Confirmation.new(donation: donation)

      confirmation.decline!

      expect(email_queue).to be_empty
      expect(donation).to be_declined
    end
  end

  def email_queue
    ActionMailer::Base.deliveries
  end
end
