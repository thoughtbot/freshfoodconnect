class DonationsController < ApplicationController
  def edit
    @donation = current_user.donations.find(params[:id])
  end
end
