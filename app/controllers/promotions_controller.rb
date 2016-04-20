class PromotionsController < ApplicationController
  def create
    user.update!(admin: true)

    redirect_to(users_url, flash: { success: t(".success", name: user.name) })
  end

  def destroy
    user.update!(admin: false)

    redirect_to(users_url, flash: { success: t(".success", name: user.name) })
  end

  private

  def user
    @user ||= User.find(params[:user_id])
  end
end
