require "rails_helper"

describe User do
  it { should have_one(:location).dependent(:destroy) }
  it { should have_many(:donations).through(:location) }
  it { should belong_to(:assigned_zone) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password).on(:create) }

  it do
    should validate_presence_of(:organic_growth_asserted_at).
      with_message(t("validations.accepted"))
  end
  it do
    should validate_presence_of(:terms_and_conditions_accepted_at).
      with_message(t("validations.accepted"))
  end

  describe ".active" do
    it "excludes deleted Users" do
      active = create(:user, :active, name: "Active")
      create(:user, :deleted, name: "Deleted")

      names = User.active.pluck(:name)

      expect(names).to eq([active.name])
    end
  end

  describe ".admins" do
    it "includes administrators" do
      admin = create(:admin, name: "Admin")
      create(:donor, name: "Donor")
      create(:cyclist, name: "Cyclist")

      names = User.admins.pluck(:name)

      expect(names).to eq([admin.name])
    end
  end

  describe ".cyclists" do
    it "includes cyclists" do
      create(:zone)
      cyclist = create(:cyclist, name: "Cyclist")
      create(:admin, name: "Admin")
      create(:donor, name: "Donor")

      names = User.cyclists.pluck(:name)

      expect(names).to eq([cyclist.name])
    end
  end

  describe ".donors" do
    it "includes donors that are not administrators" do
      donor = create(:donor, admin: false, name: "Donor")
      create(:donor, admin: true, name: "Admin/Donor")
      create(:admin, name: "Admin")
      create(:cyclist, name: "Cyclist")
      create(:donation, donor: donor)

      names = User.donors.pluck(:name)

      expect(names).to eq([donor.name])
    end
  end

  describe "#cyclist?" do
    context "when the User is assigned a zone" do
      it "returns true" do
        zone = build_stubbed(:zone)
        user = User.new(assigned_zone: zone)

        cyclist = user.cyclist?

        expect(cyclist).to be true
      end
    end

    context "when the User is not assigned a zone" do
      it "returns false" do
        user = User.new(assigned_zone: nil)

        cyclist = user.cyclist?

        expect(cyclist).to be false
      end
    end
  end

  describe "#current_donation" do
    context "when the donor is registered with a Zone scheduled for pickups" do
      it "returns their donation" do
        location = create(:location, :supported)
        donor = location.user
        scheduled_pickup = create(:scheduled_pickup, zone: location.zone)
        donation = create(
          :donation,
          donor: donor,
          scheduled_pickup: scheduled_pickup,
        )

        current_donation = donor.current_donation

        expect(current_donation).to eq(donation)
      end
    end
  end
end
