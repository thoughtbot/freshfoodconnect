require "rails_helper"

feature "Admin updates schedule pickup time" do
  scenario "from the dashboard" do
    original_start_at = 1.week.ago
    new_start_at = 1.week.from_now
    zone = create(
      :zone,
      :with_scheduled_pickups,
      weekday: original_start_at.wday,
    )

    visit_as_admin(zone)
    update_current_scheduled_pickup(start_at: new_start_at)

    expect(page).to have_text(dayname_for(new_start_at))
    expect(page).to have_success_flash
  end

  def have_success_flash
    have_text t("scheduled_pickups.update.success")
  end

  def visit_as_admin(zone)
    visit zone_path(zone, as: create(:admin))
  end

  def dayname_for(datetime)
    Weekday.find(datetime.wday).label
  end

  def update_current_scheduled_pickup(start_at:)
    within_role "pickup-time" do
      click_on t("scheduled_pickups.show.edit")
    end

    fill_form_and_submit(
      :scheduled_pickup,
      :edit,
      start_at: start_at,
      end_at: start_at + 1.hour,
    )
  end
end
