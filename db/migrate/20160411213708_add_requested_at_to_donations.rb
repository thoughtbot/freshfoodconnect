class AddRequestedAtToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :requested_at, :timestamp
  end
end
