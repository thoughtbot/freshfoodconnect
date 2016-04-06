require "rails_helper"

feature "Admin updates schedule pickup time" do
  scenario "from the dashboard" do
    original_start_at = 1.week.ago
    new_start_at = 1.week.from_now
    delivery_zone = create(
      :delivery_zone,
      :with_scheduled_pickups,
      weekday: original_start_at.wday,
    )

    visit_as_admin(delivery_zone)
    update_current_scheduled_pickup(start_at: new_start_at)

    expect(page).to have_text(dayname_for(new_start_at))
    expect(page).to have_success_flash
  end

  def have_success_flash
    have_text t("scheduled_pickups.update.success")
  end

  def visit_as_admin(delivery_zone)
    visit delivery_zone_path(delivery_zone, as: create(:user, :admin))
  end

  def dayname_for(datetime)
    Weekday.find(datetime.wday).label
  end

  def update_current_scheduled_pickup(start_at:)
    click_on t("scheduled_pickups.show.edit")

    fill_form_and_submit(
      :scheduled_pickup,
      :edit,
      start_at: start_at,
      end_at: start_at + 1.hour,
    )
  end
end
