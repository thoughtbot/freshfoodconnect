class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :email, null: false
      t.string :zipcode, null: false

      t.timestamps null: false

      t.index [:email, :zipcode], unique: true
      t.index :zipcode
    end
  end
end
