class AddMetadataToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :location_type, :integer, null: false, default: 0
    add_column :locations, :grown_on_site, :boolean, null: false, default: true
  end
end
