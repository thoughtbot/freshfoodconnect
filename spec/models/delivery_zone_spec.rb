require "rails_helper"

describe DeliveryZone do
  it { should validate_presence_of(:zipcode) }

  it { should have_many(:locations) }
  it { should have_many(:users).through(:locations) }

  context "uniqueness" do
    subject { build(:delivery_zone) }

    it { should validate_uniqueness_of(:zipcode).case_insensitive }
  end
end
