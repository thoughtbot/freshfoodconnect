require "rails_helper"

feature "Admin views donor's page" do
  scenario "from the Users page it should show donation history" do
    donor = create(:donor)
    create(:donation, :picked_up, location: donor.location)
    create(:donation, :declined)

    visit_donor_page_for(donor)

    expect(page).to have_pickup_status("success")
    expect(page).to have_pickup_status_text("success")
    expect(page).not_to have_pickup_status("no_donation")
    expect(page).not_to have_pickup_status_text("no_donation")
  end

  scenario "from the Users page it should show profile information" do
    zone = create(:zone)
    supported_location = build(:location, zone: zone)

    donor = create(:donor, location: supported_location)
    visit_donor_page_for(donor)

    expect(page).to have_text(donor.email)
    expect(page).to have_text(t("donors.show.grown_on_site"))
    expect(page).to have_text(donor.location_type)
  end

  def visit_donor_page_for(donor)
    visit users_path(as: create(:admin))

    within_record(donor) do
      click_on t("users.donors.profile_and_history")
    end
  end

  def have_pickup_status(status)
    have_css(".pickup-confirmation.#{status}")
  end

  def have_pickup_status_text(status)
    have_text t("pickups.statuses.#{status}")
  end
end
