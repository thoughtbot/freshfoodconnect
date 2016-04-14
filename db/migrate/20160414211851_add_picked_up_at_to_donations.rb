class AddPickedUpAtToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :picked_up_at, :timestamp
  end
end
