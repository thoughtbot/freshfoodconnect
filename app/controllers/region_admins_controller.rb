class RegionAdminsController < ApplicationController

  def new
    @region = Region.find(params[:region_id])
    @region_admin = RegionAdmin.new({region: @region})
  end

  def create
    @region = Region.find(region_admin_params[:region_id])
    @admin = User.find(region_admin_params[:user_id])

    @region_admin = RegionAdmin.new({ region: @region, admin: @admin })

    if @region_admin.save
      redirect_to(
        regions_path(@region),
        flash: { success: t(".success", admin_name: @region_admin.admin.name) },
      )
    else
      render :new
    end
  end

  def destroy
    @region_admin = RegionAdmin.find(params[:id])
    @region = @region_admin.region
    @admin = @region_admin.admin
    @region_admin.destroy
    redirect_to(
      @region,
      flash: { success: t(".success", admin_name: @admin.name ) },
    )
  end

  private

  def region_admin_params
    params.require(:region_admin).permit(:user_id, :region_id)
  end
end
