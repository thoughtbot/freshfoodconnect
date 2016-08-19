class RegionsController < ApplicationController
  def create
    @region = Region.new(region_params)

    if @region.save
      redirect_to(
        regions_path,
        flash: { success: t(".success", name: @region.name) }
      )
    else
      render :new
    end
  end

  def index
    @regions = Region.order(:name).all
  end

  def new
    @region = Region.new
  end

  def show
    @region = Region.find(params[:id])
  end

  private

  def region_params
    params.require(:region).permit(:name)
  end
end
