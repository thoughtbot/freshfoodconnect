class User < ActiveRecord::Base
  include Clearance::User

  has_one :location, dependent: :destroy

  validates :email, presence: true, email: true
  validates :password, presence: true, on: :create

  delegate :supported?, to: :location, allow_nil: true
end
