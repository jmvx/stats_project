class Record < Sequel::Model
  
  def before_save
    create_hash
    super
  end
  
  Record.dataset_module do
    def between_dates(start_day, end_day)
      where('date_created_at >= ? and date_created_at <= ?', start_day, end_day)
    end
    
    def where_date_and_url_are(given_day, given_url)
      where('date_created_at = ? and url = ?', given_day, given_url)
    end
  end

  # Queries database and generates hash containing top_url information
  def self.top_urls    
    # Sets date range to last 5 days
    end_day = DateTime.current.utc.to_date
    start_day = end_day - 4
    # Queries database for URLs within range
    # Groups by Date/URL and sorts by URL views
    records = Record.select{[url, count(url).as(visits), date_created_at]}
                    .between_dates(start_day, end_day)
                    .group(:date_created_at)
                    .group_append(:url)
                    .order(:date_created_at)
                    .reverse(:visits)
    # Creates Hash to return and use for JSON { date: <url data> }
    hash_by_date = Hash.new{|hash, key| hash[key] = Array.new}
    records.each do |record|
      # Create Hash { url: <url>, visits: <visits> } and add to hash_by_date
      url_visits = { :url => record.url, :visits => record[:visits] }
      hash_by_date[record.date_created_at].push(url_visits)
    end
    return hash_by_date
  end

  # Queries database and generates hash containing top_referrers information
  def self.top_referrers
    # Sets date range to last 5 days and create array of dates
    end_day = DateTime.current.utc.to_date
    start_day = end_day - 4
    date_array = get_dates(start_day, end_day)
    # Creates Hash to return and use for JSON { date: <url data> }
    hash_by_date = Hash.new{|hash, key| hash[key] = Array.new}
    date_array.each do |the_date|
      # Query database for top 10 URLs for each of the 5 dates
      top_ten = Record.select{[url, count(url).as(total)]}
                      .where('date_created_at = ?', the_date)
                      .group(:url)
                      .reverse(:total)
                      .limit(10)
      top_ten.each do |t|
        # Create URL hash
        # { url: <url>, visits: <visits>, referrers: [array of referrers] }
        url_visits = { :url => t.url, :visits => t[:total] }
        refs = []
        # Query database for top 5 referrers, for each date and url
        referrers = Record.select{[referrer, count(referrer).as(ref_total)]}
                          .where_date_and_url_are(the_date, t.url)
                          .group(:referrer)
                          .order(:url)
                          .reverse(:ref_total)
                          .limit(5)
        referrers.each do |r|
          # Create hash of referrers for each URL in the top 10 URLs and add 
          # to referrers array
          if r.referrer != nil
            ref_visits = { :url => r.referrer, :visits => r[:ref_total] }
            refs.push(ref_visits)
          end
        end
        # Add array of referrers to URL hash
        # Add URL hash to hash_by_date
        url_visits[:referrers] = refs
        hash_by_date[the_date].push(url_visits)
      end
     end
    return hash_by_date
  end

  private

    # Returns array of dates between start and end date
    def self.get_dates(start_date, end_date)
      return (start_date.to_date..end_date).map{ |date| date.strftime("%Y-%m-%d") }
    end
  
    # Use id, url, referrer, and created_at for md5 hash
    # Calculate md5 hash before_save
    def create_hash
      require 'digest/md5'
      digest_string = [self.id, self.url, self.referrer, self.created_at].join("")
      self.record_hash = Digest::MD5.hexdigest(digest_string)
    end
end
