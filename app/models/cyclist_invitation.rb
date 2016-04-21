class CyclistInvitation < SimpleDelegator
  extend ActiveModel::Naming

  def self.model_name
    ActiveModel::Name.new(CyclistInvitation)
  end

  def initialize(user)
    user.cyclist = true
    user.organic_growth_asserted = true
    user.password = SecureRandom.base64
    user.terms_and_conditions_accepted = true
    super(user)
  end

  def save
    super.tap do |saved|
      if saved
        user.forgot_password!
        ClearanceMailer.change_password(user).deliver_later
      end
    end
  end

  def to_model
    self
  end

  private

  def user
    __getobj__
  end
end
