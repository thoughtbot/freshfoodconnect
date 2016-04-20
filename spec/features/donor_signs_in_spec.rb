require "rails_helper"

feature "Donor signs in" do
  scenario "after registering" do
    donor = create(:donor)

    sign_in_as(donor)

    expect(page).to be_profile_page_for(donor)
  end

  scenario "when not registered" do
    donor = build_stubbed(:donor)

    sign_in_as(donor)

    expect(page).to be_sign_in_page
  end

  def be_profile_page_for(donor)
    have_name(donor.name)
  end

  def be_sign_in_page
    have_text t("flashes.failure_after_create")
  end
end
