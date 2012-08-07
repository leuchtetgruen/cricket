class Software < ActiveRecord::Base
  attr_accessible :title
  
  has_many :issues
  
  def to_s
    title
  end
  
  def unresolved_issues
    Issue.where(:software_id => id, :resolved => false)
  end
end
