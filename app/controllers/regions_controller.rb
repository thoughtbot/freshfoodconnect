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

  def destroy
    @region = Region.find(params[:id])

    if @region.destroy
      @region.zones.each { |zone| zone.update(region: nil) }
      redirect_to(
        regions_path,
        flash: { success: t(".success", name: @region.name) }
      )
    else
      redirect_to(
        regions_path,
        flash: { failure: t(".failure", name: @region.name) }
      )
    end
  end

  def index
    if current_user.admin?
      @regions = Region.order(:name).all
    else
      @regions = current_user.regions.order(:name)
    end
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
