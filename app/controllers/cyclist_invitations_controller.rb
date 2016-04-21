class CyclistInvitationsController < ApplicationController
  def new
    @cyclist_invitation = CyclistInvitation.new(User.new)
  end

  def show
    @cyclist_invitation = CyclistInvitation.new(find_user)
  end

  def create
    @cyclist_invitation = CyclistInvitation.new(build_user)

    if @cyclist_invitation.save
      redirect_to(@cyclist_invitation, flash: { success: t(".success") })
    else
      render :new
    end
  end

  private

  def cyclist_invitation_params
    params.require(:cyclist_invitation).permit(:email, :name)
  end

  def find_user
    User.cyclists.find(params[:id])
  end

  def build_user
    User.new(cyclist_invitation_params)
  end
end
