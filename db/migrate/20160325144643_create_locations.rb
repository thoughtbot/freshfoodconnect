class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address, null: false
      t.string :zipcode, null: false
      t.string :notes, null: false, default: ""

      t.belongs_to :user, null: false
    end
  end
end
