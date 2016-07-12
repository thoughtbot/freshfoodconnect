require "rails_helper"

feature "Unsupported donor subscribes" do
  scenario "they're prompted for their email" do
    unsupported_location = build_stubbed(:location, :unsupported)
    user = build(:user)

    visit root_path
    pre_register_with_zipcode(unsupported_location.zipcode)
    subscribe(user.email)

    expect(page).to have_thank_you_text
    expect(Subscription.last).to have_attributes(
      email: user.email,
      zipcode: unsupported_location.zipcode,
    )
  end

  scenario "admin sees their zip and email information" do
    unsupported_location = build_stubbed(:location, :unsupported)
    user = build(:user)

    visit root_path
    pre_register_with_zipcode(unsupported_location.zipcode)
    subscribe(user.email)

    visit root_path(as: create(:admin))
    expect(page).to have_text(unsupported_location.zipcode)

    click_on unsupported_location.zipcode
    expect(page).to have_text(user.email)
  end

  context "to a supported ZIP" do
    scenario "they're redirected to the registration page" do
      supported_zone = create(:zone)

      visit new_zone_subscription_path(supported_zone.zipcode)

      expect(current_path).to be_registration_page_for(supported_zone)
    end

    def be_registration_page_for(zone)
      eq(new_zone_registration_path(zone))
    end
  end

  def have_thank_you_text
    have_text t("pages.thanks.header")
  end

  def pre_register_with_zipcode(zipcode)
    fill_form_and_submit(:pre_registration, :new, zipcode: zipcode)
  end

  def subscribe(email)
    fill_form_and_submit(:subscription, :new, email: email)
  end
end
