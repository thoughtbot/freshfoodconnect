require "rails_helper"

feature "Donor describes donation" do
  scenario "after confirming their donation" do
    donation = create(:donation, :confirmed, size: "small", notes: "grains")

    visit profile_path(as: donation.donor)
    edit_donation(
      size: "medium",
      notes: "vegetables",
    )

    expect(page).to have_success_flash
    expect(page).to have_size(:medium)
    expect(page).to be_redirected_to_profile
  end

  def be_redirected_to_profile
    have_text t("profiles.show.edit")
  end

  def edit_donation(size: nil, **attributes)
    click_on t("donations.donation.edit")

    if size.present?
      choose size_i18n(size)
    end

    fill_form_and_submit(:donation, :edit, attributes)
  end

  def have_success_flash
    have_text t("donations.update.success")
  end

  def have_size(size)
    have_text size_i18n(size)
  end

  def size_i18n(size)
    t("simple_form.options.donation.size.#{size}")
  end
end
