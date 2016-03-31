class PreRegistration
  include ActiveModel::Model

  attr_accessor :zipcode

  validates :zipcode, presence: true
end
