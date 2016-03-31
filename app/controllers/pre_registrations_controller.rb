class PreRegistrationsController < ApplicationController
  skip_before_action :require_login

  def create
    @pre_registration = build_pre_registration

    if @pre_registration.valid?
      redirect_to new_registration_url(zipcode: @pre_registration.zipcode)
    else
      redirect_to root_url
    end
  end

  private

  def build_pre_registration
    PreRegistration.new(pre_registration_params)
  end

  def pre_registration_params
    params.require(:pre_registration).permit(:zipcode)
  end
end
