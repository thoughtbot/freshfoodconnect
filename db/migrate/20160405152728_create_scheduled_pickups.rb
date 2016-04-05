class CreateScheduledPickups < ActiveRecord::Migration
  def change
    create_table :scheduled_pickups do |t|
      t.string :time_range, null: false
      t.time :scheduled_for, null: false
      t.belongs_to :delivery_zone, null: false

      t.timestamps null: false
    end
  end
end
