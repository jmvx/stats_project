# Sample Data

10000.times do |n|
  a_url = [Faker::Internet.url, "http://apple.com", "https://apple.com", "https://www.apple.com", "http://developer.apple.com", "http://en.wikipedia.org", "http://opensource.org"].sample
  a_referrer = [Faker::Internet.url, "http://apple.com", "https://apple.com", "https://www.apple.com", "http://developer.apple.com", nil].sample
  time = Faker::Time.between(DateTime.now - 10, DateTime.now)

  Record.create!( url: a_url,
                  referrer: a_referrer,
                  created_at: time )
end