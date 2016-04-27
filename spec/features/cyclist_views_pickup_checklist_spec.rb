require "rails_helper"

feature "Cyclist views pickup checklist" do
  scenario "for a scheduled donation" do
    scheduled_pickup = create(:scheduled_pickup)
    cyclist = create(:cyclist)
    confirmed_donations = [
      schedule_donation_for(scheduled_pickup, :confirmed),
      schedule_donation_for(scheduled_pickup, :confirmed),
    ]
    schedule_donation_for(scheduled_pickup, :declined)

    sign_in_as(cyclist)

    expect(donor_names).to eq donors_for(confirmed_donations)
  end

  def donor_names
    all("[data-role=donor]").map(&:text)
  end

  def donors_for(donations)
    donations.map(&:donor).map(&:name)
  end

  def schedule_donation_for(scheduled_pickup, *traits)
    create(:donation, *traits, scheduled_pickup: scheduled_pickup)
  end
end
