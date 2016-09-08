class RegionAdmin < ActiveRecord::Base
  belongs_to :region
  belongs_to :admin, foreign_key: "user_id", class_name: "User"
end
