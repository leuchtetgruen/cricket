require 'net/ldap'
class LdapAuthenticator
  def self.authenticates?(username, password)
    ldap = Net::LDAP.new
    ldap.host = Settings.user.server
    ldap.auth(Settings.user.domain_prefix+username, password)
    if ldap.bind then
      users = User.where(:name => username)
      if users.empty? then
        User.create(:name => username, :type => User::TYPE_LDAP, :admin => false, :salt => "salty") if User.where(:name => username).empty?
      else
        users.first
      end
    else
      false
    end
  end
end