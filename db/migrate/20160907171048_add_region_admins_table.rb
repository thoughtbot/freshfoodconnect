class AddRegionAdminsTable < ActiveRecord::Migration
  def self.up
    create_table :region_admins do |t|
      t.integer :user_id, :region_id
    end
    # there will not be any of these in production
    regions = Region.where("user_id is not null")

    regions.each do |region|
      RegionAdmin.create({region_id: region.id, user_id: region.user_id})
    end

    remove_column :regions, :user_id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
