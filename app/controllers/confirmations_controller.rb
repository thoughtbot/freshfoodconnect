class ConfirmationsController < ApplicationController
  def create
    @confirmation = build_confirmation

    @confirmation.confirm!

    flash[:success] = t(".success")

    redirect_to :back
  end

  def update
    @donation = find_donation

    @donation.update!(confirmation_params)

    flash[:success] = t(".success")

    redirect_to :back
  end

  def destroy
    @confirmation = build_confirmation

    @confirmation.decline!

    flash[:success] = t(".success")

    redirect_to :back
  end

  private

  def build_confirmation
    Confirmation.new(donation: find_donation)
  end

  def find_donation
    current_user.donations.find(params[:donation_id])
  end

  def confirmation_params
    params.require(:confirmation).permit(:size)
  end
end
