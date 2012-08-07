module IssuesHelper
  
  def currently_selected(name)
    p = (session[:issues_filter] or params)
    p[name]
  end
  
  def currently_selected?(name)
      p = (session[:issues_filter] or params)
      (p[name] != nil)
  end
end
