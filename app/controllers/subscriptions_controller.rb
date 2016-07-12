class SubscriptionsController < ApplicationController
  skip_before_action :require_login
  before_action :redirect_if_supported, only: [:new, :create]

  def new
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

  def index
    @zipcode = params[:zipcode]
    @subscriptions = Subscription.where(zipcode: @zipcode)
  end

  private

  def redirect_if_supported
    if Zone.supported?(zipcode)
      redirect_to new_zone_registration_url(zipcode)
    end
  end

  def build_subscription
    Subscription.new(subscription_params)
  end

  def subscription_params
    params.
      require(:subscription).
      permit(:email, :zipcode).
      merge(zipcode: zipcode)
  end

  def zipcode
    params[:zone_id]
  end
end
