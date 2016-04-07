class Profile
  include ActiveModel::Model

  attr_accessor :user

  delegate(
    :email,
    :email=,
    :name,
    :name=,
    :location,
    :current_donation,
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
