# Output of 
# sequel -d mysql2://root@localhost/stats_project_development

Sequel.migration do
  change do
    create_table(:records, :ignore_index_errors=>true) do
      primary_key :id
      String :url, :size=>255
      String :referrer, :size=>255
      String :record_hash, :size=>255
      DateTime :created_at, :null=>false
      Date :date_created_at, :null=>false
      
      index [:created_at, :url], :name=>:index_records_on_created_at_and_url
      index [:date_created_at, :url], :name=>:index_records_on_date_created_at_and_url
      index [:url], :name=>:index_records_on_url
    end
    
    create_table(:schema_migrations, :ignore_index_errors=>true) do
      String :version, :size=>255, :null=>false
      
      primary_key [:version]
      
      index [:version], :name=>:unique_schema_migrations, :unique=>true
    end
  end
end
