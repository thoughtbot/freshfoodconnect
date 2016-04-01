class CreateDeliveryZones < ActiveRecord::Migration
  def change
    create_table :delivery_zones do |t|
      t.string :zipcode, null: false

      t.timestamps null: false

      t.index :zipcode, unique: true
    end
  end
end
