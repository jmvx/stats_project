class AddDateCreatedAtToRecords < ActiveRecord::Migration
  def change
    add_column :records, :date_created_at, :date
  end
end
