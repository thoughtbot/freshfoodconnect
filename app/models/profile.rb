class Profile
  include ActiveModel::Model

  attr_accessor :user

  delegate(
    :email,
    :name,
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

  def update(attributes)
    attributes.each do |method, value|
      public_send("#{method}=", value)
    end

    if valid?
      location.save
    end
  end

  def valid?
    super
    location.validate

    expose_errors

    errors.empty?
  end

  private

  def expose_errors
    location.errors.each do |key, message|
      errors[key] = message
    end
  end
end
