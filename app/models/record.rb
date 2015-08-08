class Record < ActiveRecord::Base
  before_save :create_hash
  
  def as_json(options={})
    super(  :only => [:url],
            :methods => [:visits, :referrers]
    )
  end
  
  def visits
    Record.where("date(created_at) = ?", created_at.to_date).where(url: self.url).length
  end
  
  def referrers
    array = []
    records = Record.where("date(created_at) = ?", created_at.to_date).where(url: self.url).group(:referrer).count
    records.each do |link, freq|
      ref_pair = {}
      if link != nil
        ref_pair.store(:url, link)
        ref_pair.store(:visits, freq)
        array.push(ref_pair)
        if array.size == 5
          break
        end
      end
    end
    sorted = array.sort_by { |k| k[:visits] }.reverse.first(5)
    return sorted
  end
  
  private
  
  def create_hash
    require 'digest/md5'
    digest_string = [self.id, self.url, self.referrer, self.created_at].join("")
    self.record_hash = Digest::MD5.hexdigest(digest_string)
  end
end
