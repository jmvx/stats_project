class AddIndexToRecordsUrl < ActiveRecord::Migration
  def change
    add_index :records, :url
  end
end
