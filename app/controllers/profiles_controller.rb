class ProfilesController < ApplicationController
  def show
    @profile = build_profile
  end

  def edit
    @profile = build_profile
  end

  def update
    @profile = build_profile

    if @profile.update(profile_params)
      GeocodeJob.perform_later(@profile.location)

      redirect_to profile_url, flash: { success: t(".success") }
    else
      flash[:error] = t(".error")
      render :edit
    end
  end

  private

  def build_profile
    Profile.new(user: current_user)
  end

  def profile_params
    params.require(:profile).permit(:address, :email, :name, :notes, :zipcode)
  end
end
