class DonationsController < ApplicationController
  def edit
    @donation = find_donation
  end

  def update
    @donation = find_donation

    @donation.update!(donation_params)

    flash[:success] = t(".success")

    redirect_to profile_url
  end

  private

  def donation_params
    params.require(:donation).permit(:notes, :size)
  end

  def find_donation
    current_user.donations.find(params[:id])
  end
end
