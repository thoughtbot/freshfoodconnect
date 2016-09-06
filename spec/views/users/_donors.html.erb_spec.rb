require "rails_helper"
require "clearance/rspec"

describe "users/_donors" do
  it "displays donor information" do
    sign_in_as create(:admin)

    donor = build_donor(
      name: "first last",
      address: "123 fake st.",
      zipcode: "80205",
    )

    render("users/donors", donors: [donor])

    expect(rendered).to have_text(donor.name)
    expect(rendered).to have_text(donor.address)
    expect(rendered).to have_text(donor.zipcode)
    expect(rendered).to have_promote_button
  end

  context "when the donor is also an admin" do
    it "hides the promote button" do
      donor = build_donor(
        name: "first last",
        address: "123 fake st.",
        zipcode: "80205",
        admin: true,
      )

      render("users/donors", donors: [donor])

      expect(rendered).not_to have_promote_button
    end
  end

  def have_promote_button
    have_css("[data-role=promote]")
  end

  def build_donor(name:, address:, zipcode:, admin: false)
    location = build(:location, address: address, zipcode: zipcode)

    build_stubbed(:user, name: name, location: location, admin: admin)
  end
end
