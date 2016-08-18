class RegionsController < ApplicationController
  def index
    @regions = Region.order(:name).all
  end

  def show
    @region = Region.find(params[:id])
  end
end
