module StatusHelpers
  def have_donation_status(status)
    have_css(".donation-status--#{status}")
  end
end

RSpec.configure do |config|
  config.include(StatusHelpers, type: :feature)
  config.include(StatusHelpers, type: :view)
end
