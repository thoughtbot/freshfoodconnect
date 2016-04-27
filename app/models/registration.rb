class Registration
  include ActiveModel::Model

  validates :name, presence: true
  validates :organic_growth_asserted,
    presence: { message: I18n.t("validations.accepted") }
  validates :terms_and_conditions_accepted,
    presence: { message: I18n.t("validations.accepted") }

  attr_accessor(
    :address,
    :email,
    :name,
    :password,
    :zipcode,
  )

  delegate(
    :email,
    :email=,
    :name,
    :name=,
    :organic_growth_asserted,
    :organic_growth_asserted=,
    :password,
    :password=,
    :terms_and_conditions_accepted,
    :terms_and_conditions_accepted=,
    to: :user,
  )

  delegate(
    :address,
    :address=,
    :grown_on_site,
    :grown_on_site=,
    :location_type,
    :location_type=,
    :zipcode,
    :zipcode=,
    to: :location,
  )

  def user
    @user ||= User.new
  end

  def location
    @location ||= user.build_location
  end

  def valid?
    super

    user.validate
    location.validate

    expose_errors

    errors.empty?
  end

  def invalid?
    !valid?
  end

  def save
    if valid?
      ActiveRecord::Base.transaction do
        user.save!
        location.save!
        donor_enrollment.save!

        true
      end
    end
  end

  def save!
    unless save
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  private

  def donor_enrollment
    @donor_enrollment ||= DonorEnrollment.new(location: location)
  end

  def expose_errors
    map_errors_from(user)
    map_errors_from(location)
  end

  def map_errors_from(relationship)
    relationship.errors.each do |key, message|
      errors[key] = message
    end
  end
end
