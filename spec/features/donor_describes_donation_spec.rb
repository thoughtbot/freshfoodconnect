require "rails_helper"

feature "Donor describes donation" do
  scenario "after confirming their donation" do
    donation = create(:donation, :confirmed)

    visit profile_path(as: donation.donor)
    pick_donation_size(:medium)

    expect(page).to have_success_flash
    expect(page).to have_selected_size(:medium)
  end

  def have_success_flash
    have_text t("confirmations.update.success")
  end

  def have_selected_size(size)
    have_text size_i18n(size)
  end

  def pick_donation_size(size)
    click_on t("donations.donation.edit")
    click_on size_i18n(size)
  end

  def size_i18n(size)
    t("donations.sizes.#{size}")
  end
end
