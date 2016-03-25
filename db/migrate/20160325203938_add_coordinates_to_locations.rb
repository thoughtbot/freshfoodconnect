class AddCoordinatesToLocations < ActiveRecord::Migration
  def change
    change_table :locations do |t|
      t.decimal :latitude, precision: 15, scale: 10
      t.decimal :longitude, precision: 15, scale: 10
    end
  end
end
