class Registration
  include ActiveModel::Model

  validate :location_is_supported, if: :present?
  validates :name, presence: true

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
    :password,
    :password=,
    to: :user,
  )

  delegate(
    :address,
    :address=,
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
      end
    end
  end

  def save!
    unless save
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  private

  def location_is_supported
    unless location.supported?
      errors[:zipcode] = I18n.t(".unsupported", zipcode: location.zipcode)
    end
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
