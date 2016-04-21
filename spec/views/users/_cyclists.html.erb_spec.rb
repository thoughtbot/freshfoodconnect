require "rails_helper"

describe "users/_cyclist" do
  it "displays cyclist name" do
    cyclist = build_stubbed(:cyclist, name: "first last")

    render("users/admins", admins: [cyclist])

    expect(rendered).to have_text(cyclist.name)
  end
end
