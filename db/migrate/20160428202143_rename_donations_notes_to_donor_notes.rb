class RenameDonationsNotesToDonorNotes < ActiveRecord::Migration
  def change
    rename_column :donations, :notes, :donor_notes
  end
end
