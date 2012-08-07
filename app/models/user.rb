require 'digest/sha1'
class User < ActiveRecord::Base
  attr_accessible :name, :password, :salt, :admin
  
  has_many :issues
  has_many :messages
  
  def salt_and_encrypt!
    if !salt then
      self[:salt] = ((0...10).map{ ('a'..'z').to_a[rand(26)] }.join)
    end
    self[:password] = Digest::SHA1::hexdigest(self.salt + self.password)    
  end
  
  def self.authenticates?(username, pw)
    user = User.where(:name => username).first
    if user and (Digest::SHA1::hexdigest(user.salt + pw) == user.password) then
      user.id
    else
      false
    end
  end
  
  def to_s
    self.name
  end
end
