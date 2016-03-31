class MarketingController < ApplicationController
  skip_before_action :require_login

  def index
    @pre_registration = PreRegistration.new
  end
end
