class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.belongs_to :location, null: false
      t.belongs_to :scheduled_pickup, null: false

      t.timestamp :confirmed_at
      t.timestamp :declined_at

      t.timestamps null: false
    end

    add_index :donations, [:location_id, :scheduled_pickup_id], unique: true
  end
end
