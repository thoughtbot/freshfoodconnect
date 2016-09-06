class RegionZonesController < ApplicationController
  before_action :find_region

  def new
    @unassigned_zones = Zone.where(region: nil)
  end

  def create
    @zone = Zone.find_by(zipcode: region_zones_params[:zones])

    @region.zones << @zone

    if @region.save
      redirect_to(
        @region,
        flash: { success: t(".success", zipcode: @zone.zipcode) },
      )
    else
      render :new
    end
  end

  def destroy
    @zone = Zone.find_by(zipcode: params[:id])

    @zone.update(region: nil)

    redirect_to(
      @region,
      flash: { success: t(".success", zipcode: @zone.zipcode) },
    )
  end

  private

  def find_region
    @region ||= Region.find(params[:region_id])
  end

  def region_zones_params
    params.require(:region).permit(:zones)
  end
end
