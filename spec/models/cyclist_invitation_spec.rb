require "rails_helper"

describe CyclistInvitation do
  describe "#save" do
    context "when valid" do
      it "creates a Cyclist user" do
        ensure_zone_exists!
        user = build(:user, email: "cyclist@example.com")
        cyclist = CyclistInvitation.new(user)
        password_reset_email = stub_password_reset_email_for(user)

        saved = cyclist.save

        expect(saved).to be true
        expect(user).to be_created_with(email: "cyclist@example.com")
        expect(cyclist).to be_created_with(email: "cyclist@example.com")
        expect(password_reset_email).to be_sent
      end
    end

    context "when invalid" do
      it "exposes validation errors" do
        ensure_zone_exists!
        user = build(:user, email: nil)
        cyclist = CyclistInvitation.new(user)
        password_reset_email = stub_password_reset_email_for(user)

        valid = cyclist.valid?

        expect(valid).to be false
        expect(cyclist.errors.keys).to include(:email)
        expect(password_reset_email).not_to be_sent
      end
    end

    def stub_password_reset_email_for(user)
      mail_stub = double(deliver_later: true)

      allow(ClearanceMailer).
        to receive(:change_password).
        with(user).and_return(mail_stub)

      mail_stub
    end

    def be_sent
      have_received(:deliver_later)
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
