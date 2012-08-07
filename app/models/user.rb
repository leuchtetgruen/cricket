require 'digest/sha1'
require 'ldap_authenticator'
class User < ActiveRecord::Base
  TYPE_NORMAL  = 0
  TYPE_LDAP    = 1
  
  TYPES = [TYPE_NORMAL, TYPE_LDAP]
  
  attr_accessible :name, :password, :salt, :admin, :type
  
  has_many :issues
  has_many :messages
  
  set_inheritance_column :inhet_type
  
  def salt_and_encrypt!
    if !salt then
      self[:salt] = ((0...10).map{ ('a'..'z').to_a[rand(26)] }.join)
    end
    self[:password] = Digest::SHA1::hexdigest(self.salt + self.password)    
  end
  
  def normal?
    type == TYPE_NORMAL or !Settings.user.use_ldap
  end
  
  def ldap?
    type == TYPE_LDAP
  end
  
  def not_initialized?
    (!salt or salt.empty?)
  end
  
  def self.authenticates_via_db?(username, pw)
    user = User.where(:name => username).first
    if user and (Digest::SHA1::hexdigest(user.salt + pw) == user.password) then
      user.id
    else
      false
    end
  end
  
  def self.authenticates?(username, pw)
    if Settings.user.use_ldap then
      user = LdapAuthenticator.authenticates?(username, pw)
      if user then
        return user.id
      else
        return self.authenticates_via_db?(username, pw)
      end
    else
      return self.authenticates_via_db?(username, pw)
    end
  end
  
  def to_s
    self.name
  end
end
