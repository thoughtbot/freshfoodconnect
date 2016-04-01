require "rails_helper"

describe User do
  it { should have_one(:location).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password).on(:create) }

  it { should delegate_method(:supported?).to(:location) }
end
