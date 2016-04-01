require "rails_helper"

describe Subscription do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:zipcode) }
end
