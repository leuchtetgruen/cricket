class Message < ActiveRecord::Base
  attr_accessible :issue, :text, :user
  
  belongs_to :user
  belongs_to :issue
  
end
