class ZonesController < ApplicationController
  def index
    @zones = Zone.all
  end

  def show
    @zone = Zone.find_by!(zipcode: params[:id])

    if current_scheduled_pickup.present?
      redirect_to zone_scheduled_pickup_url(
        @zone,
        current_scheduled_pickup,
      )
    else
      redirect_to new_zone_scheduled_pickup_url(@zone)
    end
  end

  def create
    @zone = Zone.new(zone_params)

    if @zone.save
      redirect_to @zone
    else
      render :new
    end
  end

  def new
    @zone = Zone.new
  end

  private

  def current_scheduled_pickup
    @zone.current_scheduled_pickup
  end

  def zone_params
    params.require(:zone).permit(
      :end_hour,
      :start_hour,
      :weekday,
      :zipcode,
    )
  end
end
