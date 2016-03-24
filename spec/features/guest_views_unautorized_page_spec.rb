require "rails_helper"

feature "Guest views unauthorized page" do
  scenario "they're redirected to the sign in page" do
    visit profile_path

    expect(page).to have_sign_in_text
  end

  def have_sign_in_text
    have_text t("helpers.submit.session.submit")
  end
end
