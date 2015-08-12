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
    end_day = DateTime.current
    start_day = end_day - 4
    date_array = get_dates(start_day, end_day)
    obj = Hash.new{|hash, key| hash[key] = Array.new}
    date_array.each do |the_date|
      records = Record.select("url, count('url') AS total, date(created_at)").where('date(created_at) = ?', the_date).group("date(created_at)").group(:url).order('date(created_at) DESC').order("count('url') DESC").limit(10)
      
      records.each do |record|
        url_visits = {}
        url_visits.store(:url, record.url)
        url_visits.store(:visits, record.total)
        obj[the_date].push(url_visits)
      end
     end
    return obj
  end
  
  private
  
    def self.get_dates(start_date, end_date)
      return (start_date.to_date..end_date.to_date).map{ |date| date.strftime("%Y-%m-%d") }
    end
  
    def create_hash
      require 'digest/md5'
      digest_string = [self.id, self.url, self.referrer, self.created_at].join("")
      self.record_hash = Digest::MD5.hexdigest(digest_string)
    end
end
