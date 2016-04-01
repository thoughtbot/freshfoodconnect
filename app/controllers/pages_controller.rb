class PagesController < ApplicationController
  include HighVoltage::StaticPage

  skip_before_filter :require_login
end
