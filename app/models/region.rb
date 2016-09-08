class Region < ActiveRecord::Base
  has_many :zones
  validates :name, presence: true, uniqueness: true

  has_many :region_admins
  has_many :admins, through: :region_admins
  #belongs_to :admin, foreign_key: "user_id", class_name: "User"

  def has_admin?
    !admins.empty?
  end
end
