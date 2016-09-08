require "rails_helper"

describe Region do
  it { should have_many(:zones) }
  it { should validate_presence_of(:name) }
end
