require "rails_helper"

feature "Admin views donor's donation history" do
  scenario "from the Users page" do
    donor = create(:donor)
    create(:donation, :picked_up, location: donor.location)
    create(:donation, :declined)

    visit_donation_history_for(donor)

    expect(page).to have_pickup_status("success")
    expect(page).to have_pickup_status_text("success")
    expect(page).not_to have_pickup_status("no_donation")
    expect(page).not_to have_pickup_status_text("no_donation")
  end

  def visit_donation_history_for(donor)
    visit users_path(as: create(:admin))

    within_record(donor) do
      click_on t("users.donors.history")
    end
  end

  def have_pickup_status(status)
    have_css(".pickup-confirmation.#{status}")
  end

  def have_pickup_status_text(status)
    have_text t("pickups.statuses.#{status}")
  end
end
