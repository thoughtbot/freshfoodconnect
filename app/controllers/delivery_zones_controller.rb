class DeliveryZonesController < ApplicationController
  def index
    @delivery_zones = DeliveryZone.all
  end

  def show
    @delivery_zone = DeliveryZone.find_by!(zipcode: params[:id])
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

  def delivery_zone_params
    params.require(:delivery_zone).permit(:zipcode)
  end
end
