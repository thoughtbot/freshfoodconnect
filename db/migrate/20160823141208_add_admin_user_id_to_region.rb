class AddAdminUserIdToRegion < ActiveRecord::Migration
  def change
    change_table :regions do |t|
      t.belongs_to :user, index: true
    end
  end
end
