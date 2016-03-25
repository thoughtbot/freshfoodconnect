class Location < ActiveRecord::Base
  belongs_to :user, touch: true

  validates :address, presence: true
  validates :user, presence: true
  validates :zipcode, presence: true
end
