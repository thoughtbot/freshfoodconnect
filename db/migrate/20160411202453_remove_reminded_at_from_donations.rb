class RemoveRemindedAtFromDonations < ActiveRecord::Migration
  def change
    remove_column :donations, :reminded_at, :timestamp
  end
end
