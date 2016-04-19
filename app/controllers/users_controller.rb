class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def destroy
    user.destroy!

    redirect_to users_url, flash: { success: t(".success", name: user.name) }
  end

  private

  def user
    @user ||= User.find(params[:id])
  end
end
