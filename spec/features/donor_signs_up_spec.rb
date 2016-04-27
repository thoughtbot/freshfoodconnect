require "rails_helper"

feature "Donor signs up" do
  context "for supported zipcode" do
    scenario "they're notified and prompted for their address" do
      zone = create(:zone)
      supported_location = build_stubbed(:location, zone: zone)
      user = build_stubbed(:user)

      visit root_path
      pre_register_with_zipcode(zone.zipcode)
      register_donor(
        address: supported_location.address,
        email: user.email,
        location_type: last_location_type,
        grown_on_site: !supported_location.grown_on_site,
      )

      expect(page).to have_text(user.email)
      expect(page).not_to have_validation_error
    end
  end

  context "for an unsupported ZIP" do
    scenario "they're redirected to that ZIP's subscribe page" do
      unsupported_zipcode = "80204"

      visit new_zone_registration_path(unsupported_zipcode)

      expect(current_path).to be_subscription_page_for(unsupported_zipcode)
    end

    def be_subscription_page_for(zipcode)
      eq(new_zone_subscription_path(zipcode))
    end
  end

  context "without accepting the Terms and Conditions" do
    scenario "displays validation errors" do
      zone = create(:zone)
      supported_location = build_stubbed(:location, zone: zone)
      user = build_stubbed(:user)

      visit root_path
      pre_register_with_zipcode(zone.zipcode)
      register_donor(
        address: supported_location.address,
        email: user.email,
        terms_and_conditions_accepted: false,
      )

      expect(page).to have_validation_error
    end
  end

  context "without asserting their donations are organic" do
    scenario "displays validation errors" do
      zone = create(:zone)
      supported_location = build_stubbed(:location, zone: zone)
      user = build_stubbed(:user)

      visit root_path
      pre_register_with_zipcode(zone.zipcode)
      register_donor(
        address: supported_location.address,
        email: user.email,
        organic_growth_asserted: false,
      )

      expect(page).to have_validation_error
    end
  end

  def have_validation_error
    have_text t("validations.accepted")
  end

  def last_location_type
    Location.location_types.keys.last.to_sym
  end

  def register_donor(location_type: nil, grown_on_site: nil, **options)
    attributes = attributes_for(:registration).
      merge(options)

    unless grown_on_site.nil?
      choose option_for(:grown_on_site, grown_on_site)
    end

    if location_type.present?
      choose option_for(:location_type, location_type)
    end

    fill_form_and_submit(:registration, :new, attributes)
  end

  def option_for(key, value)
    t("simple_form.options.registration.#{key}.#{value}")
  end

  def pre_register_with_zipcode(zipcode)
    fill_form_and_submit(:pre_registration, :new, zipcode: zipcode)
  end

  def have_pickup_text
    have_text t("profiles.show.pickup")
  end
end
