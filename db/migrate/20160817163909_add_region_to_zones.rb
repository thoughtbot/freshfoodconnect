class AddRegionToZones < ActiveRecord::Migration
  def change
    add_column :zones, :region_id, :integer
  end
end
