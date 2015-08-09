class Record < ActiveRecord::Base
  before_save :create_hash
  
  def as_json(options)
    super({ :only => [:url], :methods => [:visits]}.merge(options))
  end
  
  def visits
    records = urls_today.size
  end
  
  def referrers
    array = []
    records = urls_today.group(:referrer).count
    records.each do |link, freq|
      ref_pair = {}
      if link != nil
        ref_pair.store(:url, link)
        ref_pair.store(:visits, freq)
        array.push(ref_pair)
      end
    end
    sorted = array.sort_by { |k| k[:visits] }.reverse.first(5)
    return sorted
  end
  
  private
  
  def urls_today
    Record.where(created_at: created_at.beginning_of_day..created_at.end_of_day).where(url: self.url)
  end
  
  def create_hash
    require 'digest/md5'
    digest_string = [self.id, self.url, self.referrer, self.created_at].join("")
    self.record_hash = Digest::MD5.hexdigest(digest_string)
  end
end
