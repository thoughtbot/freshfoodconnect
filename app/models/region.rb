class Region < ActiveRecord::Base
  has_many :zones
  validates :name, presence: true, uniqueness: true
end
