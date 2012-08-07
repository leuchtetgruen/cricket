class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  
  protected
    def authorize
      redirect_to(login_url, notice: "Please log in") unless User.find_by_id(session[:user_id])
    end
    
    def current_user
      User.find_by_id(session[:user_id])
    end
    
    def logged_in?
      current_user
    end
    
    def admin?
      u = User.find_by_id(session[:user_id])
      (u and u.admin?)
    end
    
    def authorize_as_admin
      u = User.find_by_id(session[:user_id])
      redirect_to(login_url, notice: "You need to be admin to do this") unless (u and u.admin?)
    end
end
