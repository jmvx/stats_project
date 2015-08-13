class Record < ActiveRecord::Base
  before_save :create_hash
  
  def self.top_urls
   end_day = DateTime.current.utc.to_date
   start_day = end_day - 4
   records = Record.select("url, count(url) AS total, date_created_at").where('date_created_at >= ? and date_created_at <= ?', start_day, end_day).group(:date_created_at).group(:url).order("total DESC")
   start_time = Time.current.utc
   obj = Hash.new{|hash, key| hash[key] = Array.new}
   records.each do |record|
      url_visits = {}
      url_visits.store(:url, record.url)
      url_visits.store(:visits, record.total)
      obj[record.date_created_at].push(url_visits)
    end
    end_time = Time.current.utc
    answer = end_time - start_time
    p answer
    return obj
  end
  
  def self.top_referrers
    # Get array of dates to group hash by
    end_day = DateTime.current.utc.to_date
    start_day = end_day - 4
    date_array = get_dates(start_day, end_day)
    
    # initialize hash
    obj = Hash.new{|hash, key| hash[key] = Array.new}
    
    # loop over each date in array and construct a query to get top 10 urls
    date_array.each do |the_date|
      top_ten = Record.select("url, count(url) AS total").where('date_created_at = ?', the_date).group(:url).order("total DESC").limit(10)
      
      # loop over each top_10 url and query for their referrer urls and counts
      top_ten.each do |t|
        url_visits = {}
        url_visits.store(:url, t.url)
        url_visits.store(:visits, t.total)
        
        refs = []
        # Query for top 5 referrers on a particular day and for a particular url
        referrers = Record.select("referrer, count(referrer) AS ref_total").where('date_created_at = ? and url = ?', the_date, t.url).group(:referrer).order(:url).order('ref_total DESC').limit(5)
        referrers.each do |r|
          # create referrer url-visits hash
          ref_visits = {}
          ref_visits.store(:url, r.referrer)
          ref_visits.store(:visits, r.ref_total)
          # add to array of referrers
          refs.push(ref_visits)
        end
        # push array of referrers onto url_visits
        url_visits.store(:referrers, refs)
        
        obj[the_date].push(url_visits)
      end
      
     end
    return obj
  end
  
  private
  
    def self.get_dates(start_date, end_date)
      return (start_date.to_date..end_date).map{ |date| date.strftime("%Y-%m-%d") }
    end
  
    def create_hash
      require 'digest/md5'
      digest_string = [self.id, self.url, self.referrer, self.created_at].join("")
      self.record_hash = Digest::MD5.hexdigest(digest_string)
    end
end
