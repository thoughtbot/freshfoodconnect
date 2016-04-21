require "rails_helper"

describe "users/_donors" do
  it "displays donor information" do
    donor = build_donor(
      name: "first last",
      address: "123 fake st.",
      zipcode: "80205",
    )

    render("users/donors", donors: [donor])

    expect(rendered).to have_text(donor.name)
    expect(rendered).to have_text(donor.address)
    expect(rendered).to have_text(donor.zipcode)
  end

  def build_donor(name:, address:, zipcode:)
    location = build(:location, address: address, zipcode: zipcode)

    build_stubbed(:user, name: name, location: location)
  end
end
