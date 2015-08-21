# Required URLs and Referrer URLs
urls = ["http://apple.com", "https://apple.com", "https://www.apple.com", 
        "http://developer.apple.com", "http://en.wikipedia.org", "http://opensource.org"]
refs = ["http://apple.com", "https://apple.com", 
        "https://www.apple.com", "http://developer.apple.com", nil]

random = Random.new
urls_max = urls.length
refs_max = refs.length

@now = DateTime.current.utc

# Creates a new Record and saves to the database
def create_record(url, ref)
  date_time = Faker::Time.between(@now - 10, @now).utc
  Record.create( url: url,
                  referrer: ref,
                  created_at: date_time,
                  date_created_at: date_time
                )
end

# Guarantees that required URLs and Referrers are in the database at least once
urls.each_with_index do |url, i|
  ind = i.modulo(refs_max)
  create_record(url, refs[ind])
end

# Performs 1 transaction, populating the database with remaining data
data_max = 1000000 - urls_max
data_max.times do |n|
  # Generate a random number
  # If random number exceeds the size of the array, generate fake url
  # Otherwise, use the url at the array index
  # Multiplying the max value by 2 helps increases the ratio of random URLs
  url_index = random.rand(urls_max * 2)
  ref_index = random.rand(refs_max * 2)
  url = url_index < urls_max ? urls[url_index] : "http://" + Faker::Internet.domain_name
  ref = ref_index < refs_max ? refs[ref_index] : "http://" + Faker::Internet.domain_name
  create_record(url, ref)
end