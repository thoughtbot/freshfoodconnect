class ConfirmationsController < ApplicationController
  def create
    @confirmation = build_confirmation

    @confirmation.confirm!

    redirect_to edit_donation_url(@confirmation.donation)
  end

  def update
    @donation = find_donation

    @donation.update!(confirmation_params)

    redirect_to :back
  end

  def destroy
    @confirmation = build_confirmation

    @confirmation.decline!

    redirect_to profile_url
  end

  private

  def build_confirmation
    Confirmation.new(find_donation)
  end

  def find_donation
    current_user.donations.find(params[:donation_id])
  end

  def confirmation_params
    params.require(:confirmation).permit(:size)
  end
end
