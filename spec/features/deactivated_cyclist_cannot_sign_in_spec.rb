require "rails_helper"

feature "Deactivated cyclist cannot sign in" do
  scenario "when deleted by administrator" do
    cyclist = create(:cyclist, :deleted, assigned_zone: create(:zone))

    sign_in_as(cyclist)

    expect(page).to have_deactivated_error
  end

  def have_deactivated_error
    have_text t("validations.deactivated")
  end
end
