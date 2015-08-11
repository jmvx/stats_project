# Sample Data

urls = [nil, "http://apple.com", "https://apple.com", "https://www.apple.com", "http://developer.apple.com", "http://en.wikipedia.org", "http://opensource.org"]
referrers = [nil, "http://apple.com", "https://apple.com", "https://www.apple.com", "http://developer.apple.com", nil]
now = DateTime.current
  
1000000.times do |n|
  urls[0] = Faker::Internet.url
  referrers[0] = Faker::Internet.url
  a_url = urls.sample
  a_referrer = referrers.sample

  time = Faker::Time.between(now - 10, now)

  Record.create!( url: a_url,
                  referrer: a_referrer,
                  created_at: time )
end