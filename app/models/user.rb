class User < ActiveRecord::Base
  include Clearance::User

  validates :email, presence: true
  validates :password, presence: true
  validates :zipcode, presence: true
end
