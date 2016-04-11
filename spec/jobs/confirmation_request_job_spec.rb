require "rails_helper"

describe ConfirmationRequestJob do
  describe ".perform_now" do
    context "when the Donation has not yet been requested" do
      it "sends a confirmation request email" do
        donation = create(:donation, :unrequested)
        mail = stub_confirmation_mailer(donation: donation)

        ConfirmationRequestJob.perform_now(donation: donation)

        expect(mail).to have_received(:deliver_now)
        expect(donation).to be_requested
      end
    end

    context "when the Donation has already been requested" do
      it "does nothing" do
        donation = create(:donation, :requested)
        mail = stub_confirmation_mailer(donation: donation)

        ConfirmationRequestJob.perform_now(donation: donation)

        expect(mail).not_to have_received(:deliver_now)
      end
    end
  end

  def stub_confirmation_mailer(donation:)
    mail = double(deliver_now: true)

    allow(DonationsMailer).
      to receive(:request_confirmation).
      with(donation: donation).
      and_return(mail)

    mail
  end
end
