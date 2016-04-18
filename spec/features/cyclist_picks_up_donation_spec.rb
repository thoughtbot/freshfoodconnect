require "rails_helper"

feature "Cyclist picks up donation" do
  context "when the donation is picked up" do
    scenario "marking it as picked up" do
      donation = create_donation(:confirmed)

      sign_in_as_cyclist
      confirm_pickup

      expect(page).to have_confirmed_flash
      expect(page).to have_undo_pickup_button
      expect(donation.reload).to be_picked_up
    end
  end

  context "when the donation is erroneously marked as picked up" do
    scenario "marking it as not picked up" do
      donation = create_donation(:picked_up)

      sign_in_as_cyclist
      undo_pickup

      expect(page).to have_undone_flash
      expect(page).to have_confirm_pickup_button
      expect(donation.reload).not_to be_picked_up
    end
  end

  def create_donation(*traits)
    scheduled_pickup = create(:scheduled_pickup)

    create(:donation, *traits, scheduled_pickup: scheduled_pickup)
  end

  def have_confirm_pickup_button
    have_button(:confirm)
  end

  def have_undo_pickup_button
    have_button(:undo)
  end

  def have_confirmed_flash
    have_flash(:update)
  end

  def have_undone_flash
    have_flash(:destroy)
  end

  def have_button(action)
    have_css "button", text: t("pickup_checklists.show.#{action}")
  end

  def have_flash(action)
    have_text t("pickups.#{action}.success")
  end

  def confirm_pickup
    click_on t("pickup_checklists.show.confirm")
  end

  def undo_pickup
    click_on t("pickup_checklists.show.undo")
  end

  def sign_in_as_cyclist
    sign_in_as(create(:cyclist))
  end
end
