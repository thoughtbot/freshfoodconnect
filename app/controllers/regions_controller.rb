class RegionsController < ApplicationController
  def index
    @regions = Region.order(:name).all
  end
end
