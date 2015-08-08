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
    count = 0
    records = Record.where("date(created_at) = ?", created_at.to_date).where(url: self.url)
    records.each do |r|
      if r.referrer != nil
        count += 1
      end
    end
    return count
  end
  
  # def urls
  #   date = created_at.to_date
  #   unique_ids = Record.where("date(created_at) = ?", created_at.to_date).uniq.pluck(:id)
  # end
  
  private
  
  def create_hash
    require 'digest/md5'
    digest_string = [self.id, self.url, self.referrer, self.created_at].join("")
    self.record_hash = Digest::MD5.hexdigest(digest_string)
  end
end
