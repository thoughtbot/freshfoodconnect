class ConfirmationsController < ApplicationController
  def create
    @donation = find_donation

    @donation.update!(confirmed: true)

    flash[:success] = t(".success")

    redirect_to :back
  end

  def destroy
    @donation = find_donation

    @donation.update!(declined: true)

    flash[:success] = t(".success")

    redirect_to :back
  end

  private

  def find_donation
    current_user.donations.find(params[:donation_id])
  end
end
