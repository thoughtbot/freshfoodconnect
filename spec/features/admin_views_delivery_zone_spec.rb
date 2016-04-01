require "rails_helper"

feature "Admin views delivery zone" do
  scenario "from the dashboard" do
    admin = create(:user, :admin)
    location = create(:location, :supported)
    donor = create(:donor, name: "The Donor", location: location)

    visit root_path(as: admin)

    expect(page).to have_supplier_count(1)

    click_on location.zipcode

    expect(page).to have_text(donor.name)
  end

  def have_supplier_count(count)
    have_text t("delivery_zones.index.suppliers", count: count)
  end
end
