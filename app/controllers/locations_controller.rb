class LocationsController < ApplicationController
  def update
    if location.update(location_params)
      redirect_to profile_url
    else
      @profile = current_user

      render "profiles/show"
    end
  end

  private

  def location
    current_user.location
  end

  def location_params
    params.require(:location).permit(:address, :notes, :zipcode)
  end
end
