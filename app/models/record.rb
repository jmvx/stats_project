class Record < ActiveRecord::Base
  before_save :create_hash
  
  private
  
  def create_hash
    require 'digest/md5'
    digest_string = [self.id, self.url, self.referrer, created_at].join("")
    self.record_hash = Digest::MD5.hexdigest(digest_string)
  end
end
