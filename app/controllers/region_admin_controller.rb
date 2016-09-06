class RegionAdminController < ApplicationController
  before_action :find_region

  def new; end

  def create
    @admin = User.find(region_admin_params[:admin])

    @region.admin = @admin

    if @region.save
      redirect_to(
        @region,
        flash: { success: t(".success", admin_name: @region.admin.name) },
      )
    else
      render :new
    end
  end

  def destroy
    @admin = @region.admin
    @region.update(admin: nil)

    redirect_to(
      @region,
      flash: { success: t(".success", admin_name: @admin.name ) },
    )
  end

  private

  def find_region
    @region ||= Region.find(params[:region_id])
  end

  def region_admin_params
    params.require(:region).permit(:admin)
  end
end
