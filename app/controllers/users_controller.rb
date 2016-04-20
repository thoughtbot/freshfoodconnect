class UsersController < ApplicationController
  def index
    @users = User.active
  end

  def destroy
    user.update!(deleted: true)

    redirect_to users_url, flash: { success: t(".success", name: user.name) }
  end

  private

  def user
    @user ||= User.find(params[:id])
  end
end
