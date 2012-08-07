module ApplicationHelper
  
  def logged_in?
    User.find_by_id(session[:user_id])
  end
  
  def me
    logged_in?
  end
  
  def admin?
    logged_in? and me.admin?
  end
  
  def icon(name)
    raw("<i class='icon-" + name + "'></i>")
  end
  
  def flash_messages
    s = ""
    [:info, :error, :notice, :success, :alert].each do |key|
      next unless flash[key]
      s += "<div class='alert "
      s += 'alert-block' if (key == :notice)
      s += 'alert-error' if (key == :error)
      s += 'alert-error' if (key == :alert)      
      s += 'alert-info' if (key == :info)      
      s += "'><button class='close' data-dismiss='alert'>x</button>"
      s += flash[key]
    	s += "</div>"
    end
    raw(s)
  end
end
