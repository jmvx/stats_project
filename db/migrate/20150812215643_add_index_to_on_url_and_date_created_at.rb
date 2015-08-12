class AddIndexToOnUrlAndDateCreatedAt < ActiveRecord::Migration
  def change
    add_index :records, [:url, :date_created_at]
  end
end
