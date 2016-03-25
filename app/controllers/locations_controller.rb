class LocationsController < ApplicationController
  def create
    @location = build_location

    if update_location?
      redirect_to profile_url
    else
      @profile = current_user

      render "profiles/show"
    end
  end

  private

  def update_location?
    @location.update(location_params) &&
      current_user.update(zipcode: location_params[:zipcode])
  end

  def build_location
    current_user.location || current_user.build_location
  end

  def location_params
    params.require(:location).permit(:address, :notes, :zipcode)
  end
end
