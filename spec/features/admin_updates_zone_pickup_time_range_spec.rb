require "rails_helper"

feature "Admin updates zone pickup time range" do
  scenario "from the Zone page" do
    zone = create_zone(
      :with_scheduled_pickups,
      start_hour: noon,
      end_hour: one_pm,
      weekday: thursday,
    )

    visit zone_path(zone, as: create(:admin))
    update_zone(
      start_hour: eight_am,
      end_hour: nine_pm,
      weekday: friday,
    )

    expect(page).to have_success_flash
    expect(zone.reload).to be_scheduled_for(
      start_hour: eight_am,
      end_hour: nine_pm,
      weekday: friday,
    )
  end

  def be_scheduled_for(attributes)
    have_attributes(attributes.transform_values(&:value))
  end

  def create_zone(*traits, **attributes)
    create(:zone, *traits, attributes.transform_values(&:value))
  end

  def have_success_flash
    have_text t("zones.update.success")
  end

  def update_zone(attributes)
    within_role :zone do
      click_on t("scheduled_pickups.zone.edit")
    end

    fill_form_and_submit(:zone, :edit, attributes.transform_values(&:label))
  end

  def noon
    Hour.find(11)
  end

  def one_pm
    Hour.find(12)
  end

  def eight_am
    Hour.find(7)
  end

  def nine_pm
    Hour.find(20)
  end

  def thursday
    Weekday.find(5)
  end

  def friday
    Weekday.find(6)
  end
end
