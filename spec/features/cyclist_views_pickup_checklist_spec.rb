require "rails_helper"

feature "Cyclist views pickup checklist" do
  scenario "for a scheduled donation" do
    scheduled_pickup = create(:scheduled_pickup)
    cyclist = create(:cyclist)
    confirmed_donation = schedule_donation_for(scheduled_pickup, :confirmed)
    declined_donation = schedule_donation_for(scheduled_pickup, :declined)

    sign_in_as(cyclist)

    expect(page).to have_donor_for(confirmed_donation)
    expect(page).not_to have_donor_for(declined_donation)
  end

  def schedule_donation_for(scheduled_pickup, *traits)
    create(:donation, *traits, scheduled_pickup: scheduled_pickup)
  end

  def have_donor_for(donation)
    have_text(donation.donor.name)
  end
end
