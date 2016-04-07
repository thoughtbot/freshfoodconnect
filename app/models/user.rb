class User < ActiveRecord::Base
  include Clearance::User

  has_many :donations, through: :location
  has_one :location, dependent: :destroy

  validates :email, presence: true, email: true
  validates :password, presence: true, on: :create

  def current_donation
    donations.current.first
  end
end
