require "rails_helper"

describe DonationsMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include Rails.application.routes.url_helpers

  describe "#request_confirmation" do
    it "includes a link to the Donation's edit page" do
      donation = create(:donation, :pending)
      donor = donation.donor

      mail = DonationsMailer.request_confirmation(donation: donation)

      expect(mail).to be_delivered_to(donor.email)
      expect(mail).to have_subject_for(donation)
      expect(mail).to mention_time_range_for(donation)

      expect(mail).to have_confirmation_prompt
      expect(mail).to have_edit_link_for(donation)
    end
  end

  def have_edit_link_for(donation)
    have_body_text(edit_donation_url(donation))
  end

  def have_confirmation_prompt
    have_body_text(t("donations_mailer.request_confirmation.prompt"))
  end

  def mention_time_range_for(donation)
    have_body_text donation.time_range.to_s
  end

  def have_subject_for(donation)
    have_subject subject_for(donation)
  end

  def subject_for(donation)
    t(
      "donations_mailer.request_confirmation.subject",
      range: donation.time_range,
    )
  end
end
