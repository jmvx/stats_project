class Record < ActiveRecord::Base
  before_save :create_hash  
  
  def as_json(options)
    super({ :only => [], :methods => [:top_urls]}.merge(options))
  end
  
  def last_five_days
    Record.order('created_at desc').uniq.limit(5).pluck("DATE_FORMAT(created_at, '%Y-%m-%d')")
  end
  
  def the_date
    self.created_at.to_date
  end
  
  def top_urls
    array = []
    records = urls_today.group(:url).count.sort_by {|link, freq| freq }.reverse
    records.each do |link, freq|
      url_visits = {}
      url_visits.store(:url, link)
      url_visits.store(:visits, freq)
      array.push(url_visits)
    end
    return array
  end
  
  def top_referrers 
    array = []
    records = urls_today.group(:url).count.sort_by {|link, freq| freq }.reverse.first(10)
    records.each do |link, freq|
      url_visits = {}
      url_visits.store(:url, link)
      url_visits.store(:visits, freq)
      records_refs = urls_today.where('url = ?', link).group(:referrer).count.sort_by {|ref_link, ref_freq| ref_freq }.reverse.first(5)
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
  
  def urls_today
    Record.where('date(created_at) = ?', the_date)
  end
  
  def create_hash
    require 'digest/md5'
    digest_string = [self.id, self.url, self.referrer, self.created_at].join("")
    self.record_hash = Digest::MD5.hexdigest(digest_string)
  end
end
