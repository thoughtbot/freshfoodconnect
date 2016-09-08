class User < ActiveRecord::Base
  include Clearance::User

  time_for_a_boolean :deleted
  time_for_a_boolean :organic_growth_asserted
  time_for_a_boolean :terms_and_conditions_accepted

  belongs_to :assigned_zone, class_name: Zone
  has_many :donations, through: :location
  has_one :location, dependent: :destroy

  has_many :region_admins
  has_many :regions, through: :region_admins

  validates :email, presence: true, email: true
  validates :name, presence: true
  validates :organic_growth_asserted_at, presence: {
    message: I18n.t("validations.accepted"),
  }
  validates :password, presence: true, on: :create
  validates :terms_and_conditions_accepted_at, presence: {
    message: I18n.t("validations.accepted"),
  }

  delegate(:address, :zipcode, :location_type, to: :location)

  def self.active
    where(deleted_at: nil)
  end

  def self.admins
    where(admin: true)
  end

  def self.cyclists
    where.not(assigned_zone_id: nil)
  end

  def self.donors
    joins(:location)
  end

  def cyclist=(is_cyclist)
    if is_cyclist
      self.assigned_zone = Zone.first
    else
      self.assigned_zone = nil
    end
  end

  def cyclist?
    assigned_zone.present?
  end

  def staff?
    regional_admin? || cyclist?
  end

  def current_donation
    donations.current.first
  end

  def regional_admin?
    admin? || regions.any?
  end

end
