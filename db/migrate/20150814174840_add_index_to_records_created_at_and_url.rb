class AddIndexToRecordsCreatedAtAndUrl < ActiveRecord::Migration
  def change
    add_index :records, [:created_at, :url]
  end
end
