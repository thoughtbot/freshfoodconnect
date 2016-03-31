require "rails_helper"

describe PreRegistration do
  it { should validate_presence_of(:zipcode) }
end
