require "rails_helper"

describe User do
  it { should have_one(:location).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  it { should delegate_method(:supported?).to(:location) }
end
