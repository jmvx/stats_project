class AddIndexToOnDateCreatedAtAndUrl < ActiveRecord::Migration
  def change
    add_index :records, [:date_created_at, :url]
  end
end
