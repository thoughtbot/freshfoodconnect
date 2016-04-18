class AddAssignedZoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :assigned_zone_id, :integer

    add_index :users, :assigned_zone_id
  end
end
