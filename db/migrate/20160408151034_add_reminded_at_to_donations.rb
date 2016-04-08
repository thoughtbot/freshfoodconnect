class AddRemindedAtToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :reminded_at, :timestamp
  end
end
