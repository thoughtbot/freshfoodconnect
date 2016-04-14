class PickupChecklistsController < ApplicationController
  def show
    @pickup_checklist = PickupChecklist.new(find_scheduled_pickup)
  end

  private

  def find_scheduled_pickup
    zone.scheduled_pickups.find(params[:scheduled_pickup_id])
  end

  def zone
    @zone ||= Zone.find_by!(zipcode: params[:zone_id])
  end
end
