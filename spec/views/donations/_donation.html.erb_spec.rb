require "rails_helper"

describe "donations/donation" do
  context "when the donation is pending" do
    it "hides additional information" do
      donation = build_stubbed(:donation, :pending)

      render("donations/donation", donation: donation)

      expect(rendered).to have_enabled_button(:confirm)
      expect(rendered).to have_enabled_button(:decline)
      expect_rendered_not_to_have_information
    end
  end

  context "when the donation is confirmed" do
    it "displays additional information" do
      donation = build_stubbed(:donation, :confirmed)

      render("donations/donation", donation: donation)

      expect(rendered).to have_edit_link_for(donation)
      expect(rendered).to have_donation_status(:confirmed)
      expect(rendered).to have_role("donation-size")
      expect(rendered).to have_role("donation-notes")
    end
  end

  context "when the donation is declined" do
    it "hides additional information" do
      donation = build_stubbed(:donation, :declined)

      render("donations/donation", donation: donation)

      expect(rendered).to have_edit_link_for(donation)
      expect(rendered).to have_donation_status(:declined)
      expect_rendered_not_to_have_information
    end
  end

  def expect_rendered_not_to_have_information
    expect(rendered).not_to have_role("donation-size")
    expect(rendered).not_to have_role("donation-notes")
  end

  def have_edit_link_for(donation)
    have_css(%{a[href="#{edit_donation_path(donation)}"]})
  end

  def have_enabled_button(type)
    have_css("button:not([disabled])", text: t("donations.#{type}.text"))
  end

  def have_role(role)
    have_css(%{[data-role="#{role}"]})
  end
end
