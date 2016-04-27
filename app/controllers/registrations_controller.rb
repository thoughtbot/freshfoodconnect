class RegistrationsController < ApplicationController
  skip_before_action :require_login
  before_action :redirect_if_unsupported, only: [:new]

  def new
    @registration = Registration.new(zipcode: zone.zipcode)
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

  def redirect_if_unsupported
    zone = Zone.find_by(zipcode: zipcode)

    if zone.nil?
      redirect_to new_zone_subscription_url(zipcode)
    end
  end

  def zone
    Zone.find_by!(zipcode: zipcode)
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
      ).
      merge(zipcode: zone.zipcode)
  end

  def zipcode
    params[:zone_id]
  end
end
