class DeliveryZonesController < ApplicationController
  def index
    @delivery_zones = DeliveryZone.all
  end

  def show
    @delivery_zone = DeliveryZone.find_by!(zipcode: params[:id])

    if current_scheduled_pickup.present?
      redirect_to delivery_zone_scheduled_pickup_url(
        @delivery_zone,
        current_scheduled_pickup,
      )
    else
      redirect_to new_delivery_zone_scheduled_pickup_url(@delivery_zone)
    end
  end

  def create
    @delivery_zone = DeliveryZone.new(delivery_zone_params)

    if @delivery_zone.save
      redirect_to @delivery_zone
    else
      render :new
    end
  end

  def new
    @delivery_zone = DeliveryZone.new
  end

  private

  def current_scheduled_pickup
    @delivery_zone.current_scheduled_pickup
  end

  def delivery_zone_params
    params.require(:delivery_zone).permit(
      :end_hour,
      :start_hour,
      :weekday,
      :zipcode,
    )
  end
end
