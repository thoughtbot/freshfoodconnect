require "rails_helper"

feature "Donor edits pickup location" do
  scenario "from profile" do
    location = create(:location, :residence, :grown_on_site)
    donor = create(:donor, location: location)
    new_settings = {
      location_type: "business",
      grown_on_site: false,
    }

    visit root_path(as: donor)
    edit_location(new_settings)

    expect(page).to have_success_flash
    expect(page).to have_setting(new_settings[:location_type])
    expect(page).to have_setting(new_settings[:grown_on_site])
  end

  def have_success_flash
    have_text t("locations.update.success")
  end

  def have_setting(value)
    have_css(%{[checked][value="#{value}"]})
  end

  def edit_location(location_type: nil, grown_on_site: nil, **attributes)
    choose option_for(:location_type, location_type)

    choose option_for(:grown_on_site, grown_on_site)

    fill_form_and_submit(:location, :edit, attributes)
  end

  def option_for(key, value)
    t("simple_form.options.location.#{key}.#{value}")
  end
end
