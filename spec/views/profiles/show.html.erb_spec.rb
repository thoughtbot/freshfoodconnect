require "rails_helper"

describe "profiles/show" do
  it "displays profile information" do
    location = build_stubbed(:location, notes: "on the porch")
    donation = build_stubbed(:donation, location: location)
    profile = build_profile(
      address: "123 Fake St.",
      email: "user@example.com",
      name: "First Last",
      zipcode: "90210",
      notes: location.notes,
      current_donation: donation,
    )
    assign(:profile, profile)

    render

    expect(rendered).to have_text(profile.address)
    expect(rendered).to have_text(profile.email)
    expect(rendered).to have_text(profile.name)
    expect(rendered).to have_text(profile.notes)
    expect(rendered).to have_text(profile.zipcode)
  end

  context "when there isn't a current donation" do
    it "informs the User there won't be a donation" do
      profile = build_profile(current_donation: nil)
      assign(:profile, profile)

      render

      expect(rendered).to have_text(t("donations.current.none"))
    end
  end

  def build_profile(**options)
    attributes = options.reverse_merge(
      address: "",
      email: "",
      name: "",
      notes: "",
      zipcode: "",
    )

    double(Profile, attributes)
  end

  before do
    view.signed_in = true
  end
end
