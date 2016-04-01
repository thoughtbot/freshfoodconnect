class ChangeLocationNotesToText < ActiveRecord::Migration
  def up
    change_column :locations, :notes, :text
  end

  def down
    change_column :locations, :notes, :string
  end
end
