class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :url
      t.string :referrer
      t.string :record_hash

      t.timestamps null: false
    end
  end
end
