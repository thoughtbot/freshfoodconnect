class PickupsController < ApplicationController
  def destroy
    donation.update!(picked_up: false)

    redirect_to checklist_url, flash: { success: t(".success") }
  end

  def update
    donation.update!(picked_up: true)

    redirect_to checklist_url, flash: { success: t(".success") }
  end

  private

  def checklist_url
    zone_scheduled_pickup_checklist_url(
      donation.zone,
      donation.scheduled_pickup,
    )
  end

  def donation
    @donation ||= Donation.find(params[:donation_id])
  end
end
