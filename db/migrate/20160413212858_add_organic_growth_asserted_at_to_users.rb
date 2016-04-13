class AddOrganicGrowthAssertedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :organic_growth_asserted_at, :timestamp
  end
end
