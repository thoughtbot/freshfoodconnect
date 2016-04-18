class LatestPickupChecklistsController < ApplicationController
  def show
    redirect_to latest_pickup_checklist_url
  end

  private

  def latest_pickup_checklist_url
    zone_scheduled_pickup_checklist_url(
      assigned_zone,
      latest_scheduled_pickup,
    )
  end

  def latest_scheduled_pickup
    assigned_zone.scheduled_pickups.current.last
  end

  def assigned_zone
    current_user.assigned_zone
  end
end
