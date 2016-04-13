class AddTermsAndConditionsAcceptedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terms_and_conditions_accepted_at, :timestamp
  end
end
