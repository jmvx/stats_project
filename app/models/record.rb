class Record < ActiveRecord::Base
  before_save :create_hash
  
  def self.top_urls
   end_day = DateTime.current
   start_day = end_day-5
   records = Record.select("url, count('url') AS total, date(created_at) AS date").where(:created_at => start_day..end_day).group("date(created_at)").group(:url).order('date(created_at) DESC').order("count('url') DESC")
   obj = Hash.new{|hash, key| hash[key] = Array.new}
   records.each do |record|
      url_visits = {}
      url_visits.store(:url, record.url)
      url_visits.store(:visits, record.total)
      obj[record.date].push(url_visits)
    end
    return obj
  end
  
  def self.top_referrers 
    array = []
    urls = get_urls_today
    records = urls.group(:url).count.sort_by {|link, freq| freq }.reverse!.first(10)
    records.each do |link, freq|
      
      url_visits = {}
      url_visits.store(:url, link)
      url_visits.store(:visits, freq)
      
      records_refs = Record.where('date(created_at) = ? AND url = ?', the_date, link).group(:referrer).count.sort_by {|ref_link, ref_freq| ref_freq }.reverse.first(5)
      ref_array = []
      records_refs.each do |rlink, rfreq|
        if rlink != nil
          refs = {}
          refs.store(:url, rlink)
          refs.store(:visits, rfreq)
          ref_array.push(refs)
          url_visits.store(:referrers, ref_array)
        end
        
      end
      array.push(url_visits)
    end
    return array
    
  end
  
  private
  
  def create_hash
    require 'digest/md5'
    digest_string = [self.id, self.url, self.referrer, self.created_at].join("")
    self.record_hash = Digest::MD5.hexdigest(digest_string)
  end
end
