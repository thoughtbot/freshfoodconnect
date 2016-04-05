class CreateScheduledPickups < ActiveRecord::Migration
  def change
    create_table :scheduled_pickups do |t|
      t.belongs_to :delivery_zone, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.timestamps null: false
    end
  end
end
