class AddSizeToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :size, :integer, default: 0, null: false

    add_index :donations, :size
  end
end
