class User < ActiveRecord::Base
  include Clearance::User

  time_for_a_boolean :organic_growth_asserted
  time_for_a_boolean :terms_and_conditions_accepted

  has_many :donations, through: :location
  has_one :location, dependent: :destroy

  validates :email, presence: true, email: true
  validates :organic_growth_asserted_at, presence: {
    message: I18n.t("validations.accepted"),
  }
  validates :password, presence: true, on: :create
  validates :terms_and_conditions_accepted_at, presence: {
    message: I18n.t("validations.accepted"),
  }

  def current_donation
    donations.current.first
  end
end
