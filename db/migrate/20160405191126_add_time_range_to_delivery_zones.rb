class AddTimeRangeToDeliveryZones < ActiveRecord::Migration
  def change
    add_column :delivery_zones, :start_hour, :integer, null: false, default: 0
    add_column :delivery_zones, :end_hour, :integer, null: false, default: 0
    add_column :delivery_zones, :weekday, :integer, null: false, default: 0
  end
end
