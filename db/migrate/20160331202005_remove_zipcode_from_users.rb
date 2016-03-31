class RemoveZipcodeFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, column: :zipcode
    remove_column :users, :zipcode, :string, null: false
  end
end
