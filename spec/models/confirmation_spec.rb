require "rails_helper"

describe Confirmation do
  describe "#confirm!" do
    it "confirms the donation" do
      donation = build(:donation, confirmed: nil)
      confirmation = Confirmation.new(donation)

      confirmation.confirm!

      expect(donation).to be_confirmed
    end
  end

  describe "#decline!" do
    it "declines the donation" do
      donation = build(:donation, declined: false)
      confirmation = Confirmation.new(donation)

      confirmation.decline!

      expect(donation).to be_declined
    end
  end

  describe "#request!" do
    context "when the Donation is pending" do
      context "and not yet requested" do
        it "sends a request email" do
          donation = create(:donation, :pending, :unrequested)
          confirmation = Confirmation.new(donation)
          allow(ConfirmationRequestJob).to request_confirmation_for(donation)

          confirmation.request!

          expect(ConfirmationRequestJob).
            to have_requested_confirmation_for(donation)
        end
      end

      context "and already requested" do
        it "does nothing" do
          donation = create(:donation, :pending, :requested)
          confirmation = Confirmation.new(donation)
          allow(ConfirmationRequestJob).to stub_confirmation

          confirmation.request!

          expect(ConfirmationRequestJob).not_to have_confirmed
        end
      end
    end

    context "when the Donation is not pending" do
      it "does nothing" do
        donation = create(:donation, :confirmed)
        confirmation = Confirmation.new(donation)
        allow(ConfirmationRequestJob).to stub_confirmation

        confirmation.request!

        expect(ConfirmationRequestJob).not_to have_confirmed
      end
    end
  end

  def have_requested_confirmation_for(donation)
    have_confirmed.with(donation: donation)
  end

  def have_confirmed
    have_received(:perform_now)
  end

  def stub_confirmation
    receive(:perform_now)
  end

  def request_confirmation_for(donation)
    stub_confirmation.with(donation: donation)
  end
end
