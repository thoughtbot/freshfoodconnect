module ViewStubHelpers
  def signed_in=(signed_in)
    @signed_in = signed_in
  end

  def signed_in?
    @signed_in
  end
end

RSpec.configure do |config|
  config.before type: :view do
    view.extend(ViewStubHelpers)
  end
end
