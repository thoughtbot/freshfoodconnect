class ScheduledPickupsController < ApplicationController
  def show
    @scheduled_pickup = find_scheduled_pickup
  end

  def edit
    @scheduled_pickup = find_scheduled_pickup
  end

  def new
    @scheduled_pickup = build_scheduled_pickup_with_defaults

    if @scheduled_pickup.persisted?
      redirect_to edit_delivery_zone_scheduled_pickup_url(
        delivery_zone,
        @scheduled_pickup,
      )
    end
  end

  def create
    @scheduled_pickup = build_scheduled_pickup

    @scheduled_pickup.save!

    redirect_to delivery_zone_scheduled_pickup_url(
      delivery_zone,
      @scheduled_pickup,
    )
  end

  def update
    @scheduled_pickup = find_scheduled_pickup

    @scheduled_pickup.update!(scheduled_pickup_params)

    flash[:success] = t(".success")

    redirect_to delivery_zone_scheduled_pickup_url(
      delivery_zone,
      @scheduled_pickup,
    )
  end

  private

  def scheduled_pickup_params
    params.require(:scheduled_pickup).permit(:start_at, :end_at)
  end

  def build_scheduled_pickup_with_defaults
    PickupScheduler.new(delivery_zone).scheduled_pickup
  end

  def build_scheduled_pickup
    delivery_zone.scheduled_pickups.build(scheduled_pickup_params)
  end

  def find_scheduled_pickup
    delivery_zone.scheduled_pickups.find(params[:id])
  end

  def delivery_zone
    @delivery_zone ||= DeliveryZone.find_by!(zipcode: params[:delivery_zone_id])
  end
end
