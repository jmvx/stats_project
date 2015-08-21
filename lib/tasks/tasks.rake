namespace :db do
  # Loading the migration extension from the sequel gem
  require 'sequel/extensions/migration'
  
  # rake db:migrate
  desc "Run database migrations"
  task :migrate do
    Rake::Task['environment'].invoke(Rails.env)
    Sequel::Migrator.apply(DB, File.join(Rails.root, 'db', 'migrations'))
  end
  
  # rake db:seed
  desc "Seed the database with dummy data"
  task :seed do
    Rake::Task['environment'].invoke(Rails.env)
    require File.join(Rails.root, 'db', 'seeds.rb')
  end
  
  # rake db:drop_tables
  desc "Drop all tables"
  task :drop_tables do
    Rake::Task['environment'].invoke(Rails.env)
    Sequel::Model.db.drop_table *Sequel::Model.db.tables
  end
  
  # rake db:reset
  desc "Reset database (drop, migrate, seed)"
  task :reset => [:drop_tables, :migrate, :seed]
  
end