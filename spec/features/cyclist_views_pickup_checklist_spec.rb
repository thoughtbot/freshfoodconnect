require "rails_helper"

feature "Cyclist views pickup checklist" do
  scenario "for a scheduled donation" do
    scheduled_pickup = create(:scheduled_pickup)
    confirmed_donation = schedule_donation_for(scheduled_pickup, :confirmed)
    declined_donation = schedule_donation_for(scheduled_pickup, :declined)

    visit_pickup_checklist_for(scheduled_pickup.zone)

    expect(page).to have_donor_for(confirmed_donation)
    expect(page).not_to have_donor_for(declined_donation)
  end

  def schedule_donation_for(scheduled_pickup, *traits)
    create(:donation, *traits, scheduled_pickup: scheduled_pickup)
  end

  def have_donor_for(donation)
    have_text(donation.donor.name)
  end

  def visit_pickup_checklist_for(zone)
    visit zones_path(as: create(:cyclist))

    click_on zone.zipcode
    click_on t("scheduled_pickups.donations.checklist")
  end
end
