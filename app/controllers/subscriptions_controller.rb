class SubscriptionsController < ApplicationController
  skip_before_action :require_login

  def new
    if zipcode.blank?
      redirect_to root_url
    end

    @subscription = Subscription.new(zipcode: zipcode)
  end

  def create
    @subscription = build_subscription

    if @subscription.save
      redirect_to page_url(:thanks)
    else
      render :new
    end
  end

  private

  def build_subscription
    Subscription.new(subscription_params)
  end

  def subscription_params
    params.require(:subscription).permit(:email, :zipcode)
  end

  def zipcode
    params[:zipcode]
  end
end
