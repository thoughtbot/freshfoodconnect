require "rails_helper"

describe "profiles/show" do
  it "displays profile information" do
    profile = double(
      Profile,
      address: "123 Fake St.",
      email: "user@example.com",
      name: "First Last",
      notes: "On the porch",
      zipcode: "90210",
    )
    assign(:profile, profile)

    render

    expect(rendered).to have_text(profile.address)
    expect(rendered).to have_text(profile.email)
    expect(rendered).to have_text(profile.name)
    expect(rendered).to have_text(profile.notes)
    expect(rendered).to have_text(profile.zipcode)
  end

  before do
    view.signed_in = true
  end
end
