@records.each do |record|
  json.extract! record, :created_at, :url, :referrer
end
