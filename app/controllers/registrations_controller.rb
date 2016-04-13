class RegistrationsController < ApplicationController
  skip_before_action :require_login

  def new
    if zipcode.present?
      @registration = Registration.new(zipcode: zipcode)
    else
      redirect_to root_url
    end
  end

  def create
    @registration = build_registration

    if @registration.save
      sign_in(@registration.user)

      redirect_to profile_url(anchor: :welcome)
    else
      render :new
    end
  end

  private

  def zipcode
    params[:zipcode]
  end

  def build_registration
    Registration.new(registration_params)
  end

  def registration_params
    params.require(:registration).
      permit(
        :address,
        :email,
        :grown_on_site,
        :location_type,
        :name,
        :organic_growth_asserted,
        :password,
        :terms_and_conditions_accepted,
        :zipcode,
      )
  end
end
