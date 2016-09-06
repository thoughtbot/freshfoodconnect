class Region < ActiveRecord::Base
  has_many :zones
  validates :name, presence: true, uniqueness: true

  belongs_to :admin, foreign_key: "user_id", class_name: "User"

  def has_admin?
    !admin.nil?
  end
end
