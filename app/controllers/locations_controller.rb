class LocationsController < ApplicationController
  def update
    @location = find_location

    @location.update!(location_params)

    redirect_to profile_url, flash: { success: t(".success") }
  end

  private

  def location_params
    params.require(:location).permit(:location_type, :grown_on_site)
  end

  def find_location
    current_user.location
  end
end
