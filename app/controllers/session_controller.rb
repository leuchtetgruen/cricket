class SessionController < ApplicationController
  skip_before_filter :authorize  
  
  def new
  end

  def create
    if session[:user_id] = User.authenticates?(params[:name], params[:password]) then
      redirect_to start_url
    else
      redirect_to login_url, :alert => "Invalid username / password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, :notice => "You have been logged out"
  end
end
