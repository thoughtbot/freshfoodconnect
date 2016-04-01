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
      redirect_to profile_url
    else
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
