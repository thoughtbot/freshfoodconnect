require "rails_helper"

describe CyclistInvitation do
  describe "#save" do
    context "when valid" do
      it "creates a Cyclist user" do
        ensure_zone_exists!
        user = User.new(email: "cyclist@example.com")
        cyclist = CyclistInvitation.new(user)

        saved = cyclist.save

        expect(saved).to be true
        expect(user).to be_created_with(email: "cyclist@example.com")
        expect(cyclist).to be_created_with(email: "cyclist@example.com")
      end
    end

    context "when invalid" do
      it "exposes validation errors" do
        ensure_zone_exists!
        user = User.new(email: nil)
        cyclist = CyclistInvitation.new(user)

        valid = cyclist.valid?

        expect(valid).to be false
        expect(cyclist.errors.keys).to include(:email)
      end
    end

    def be_created_with(email:)
      have_attributes(
        cyclist?: true,
        email: email,
        invalid?: false,
        persisted?: true,
        valid?: true,
      )
    end

    def ensure_zone_exists!
      create(:zone)
    end
  end
end
