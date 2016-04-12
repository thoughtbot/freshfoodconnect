require "rails_helper"

describe "profiles/show" do
  it "displays profile information" do
    user = build_stubbed(
      :user,
      email: "user@example.com",
      name: "First Last",
    )
    location = build_stubbed(
      :location,
      user: user,
      address: "123 Fake St.",
      zipcode: "90210",
    )
    build_stubbed(:donation, location: location)
    profile = Profile.new(user: user)
    assign(:profile, profile)

    render

    expect(rendered).to have_text(profile.address)
    expect(rendered).to have_text(profile.email)
    expect(rendered).to have_text(profile.name)
    expect(rendered).to have_text(profile.zipcode)
  end

  context "when there isn't a current donation" do
    it "informs the User there won't be a donation" do
      donor = build_stubbed(:donor)
      profile = Profile.new(user: donor)
      assign(:profile, profile)

      render

      expect(rendered).to have_unscheduled_donation_text
    end
  end

  def have_unscheduled_donation_text
    have_text t("unscheduled_donations.unscheduled_donation.text")
  end

  before do
    view.signed_in = true
  end
end
