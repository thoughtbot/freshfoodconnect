class DonorsController < ApplicationController
  def show
    @donor = find_donor
  end

  private

  def find_donor
    User.donors.find(params[:id])
  end
end
