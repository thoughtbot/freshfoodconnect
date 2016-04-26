class Profile
  include ActiveModel::Model

  attr_accessor :user

  delegate(
    :email,
    :email=,
    :name,
    :name=,
    :phone_number=,
    :location,
    to: :user,
  )

  delegate(
    :address,
    :address=,
    :notes,
    :notes=,
    :zipcode,
    :zipcode=,
    :persisted?,
    to: :location,
  )

  def current_donation
    user.current_donation || UnscheduledDonation.new
  end

  def phone_number
    user.phone_number.to_s.phony_formatted(normalize: :US, spaces: "-")
  end

  def update(attributes)
    attributes.each do |method, value|
      public_send("#{method}=", value)
    end

    if valid?
      ActiveRecord::Base.transaction do
        user.save!
        location.save!
      end
    end
  end

  def valid?
    super
    user.validate
    location.validate

    expose_errors

    errors.empty?
  end

  private

  def expose_errors
    [
      user,
      location,
    ].each do |relationship|
      relationship.errors.each do |key, message|
        errors[key] = message
      end
    end
  end
end
