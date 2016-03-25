require "rails_helper"

describe Location do
  it { should belong_to(:user).touch(true) }

  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:zipcode) }
end
