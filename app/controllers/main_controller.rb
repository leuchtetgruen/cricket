class MainController < ApplicationController
  before_filter :authorize, :except => [:start]
  
  def start
    if admin? then
      unless (User.where('name != ?', 'admin').any?) then
        redirect_to users_path, :notice => 'Please create a new user to make this tool useful' 
        return
      end
    end
    if logged_in? then
      if (Software.count == 0) then
        redirect_to softwares_path
      else
        redirect_to issues_path
      end
    else
      unless (User.authenticates?('admin', 'admin')) then
        redirect_to softwares_path
      else
        redirect_to login_path
      end
    end    
  end
  

end

