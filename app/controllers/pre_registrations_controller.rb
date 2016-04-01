class PreRegistrationsController < ApplicationController
  skip_before_action :require_login
  before_action :redirect_if_zipcode_missing

  def create
    if pre_registration.supported?
      redirect_to new_registration_url(zipcode: pre_registration.zipcode)
    else
      redirect_to new_subscription_url(zipcode: pre_registration.zipcode)
    end
  end

  private

  def redirect_if_zipcode_missing
    if pre_registration.invalid?
      redirect_to root_url
    end
  end

  def pre_registration
    PreRegistration.new(pre_registration_params)
  end

  def pre_registration_params
    params.require(:pre_registration).permit(:zipcode)
  end
end
