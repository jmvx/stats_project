require 'sequel'
DB = Sequel.connect(YAML.load(File.read(File.join(Rails.root, 'config', 'database.yml')))[Rails.env])
