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
      redirect_to edit_zone_scheduled_pickup_url(zone, @scheduled_pickup)
    end
  end

  def create
    @scheduled_pickup = build_scheduled_pickup

    @scheduled_pickup.save!

    redirect_to_scheduled_pickup
  end

  def update
    @scheduled_pickup = find_scheduled_pickup

    @scheduled_pickup.update!(scheduled_pickup_params)

    redirect_to_scheduled_pickup
  end

  private

  def redirect_to_scheduled_pickup
    redirect_to(
      zone_scheduled_pickup_url(zone, @scheduled_pickup),
      flash: { success: t(".success") },
    )
  end

  def scheduled_pickup_params
    params.require(:scheduled_pickup).permit(:start_at, :end_at)
  end

  def build_scheduled_pickup_with_defaults
    PickupScheduler.new(zone).scheduled_pickup
  end

  def build_scheduled_pickup
    zone.scheduled_pickups.build(scheduled_pickup_params)
  end

  def find_scheduled_pickup
    zone.scheduled_pickups.find(params[:id])
  end

  def zone
    @zone ||= Zone.find_by!(zipcode: params[:zone_id])
  end
end
