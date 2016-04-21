require "rails_helper"

describe "users/_admin" do
  it "displays admin name" do
    admin = build_stubbed(:admin, name: "first last")

    render("users/admins", admins: [admin])

    expect(rendered).to have_text(admin.name)
  end
end
