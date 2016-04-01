require "rails_helper"

feature "Unsupported donor subscribes" do
  scenario "they're prompted for their email" do
    unsupported_location = build(:location, :unsupported)
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
