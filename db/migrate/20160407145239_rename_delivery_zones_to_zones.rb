class RenameDeliveryZonesToZones < ActiveRecord::Migration
  def change
    rename_table :delivery_zones, :zones
    rename_column :scheduled_pickups, :delivery_zone_id, :zone_id
  end
end
