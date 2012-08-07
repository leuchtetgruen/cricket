class Issue < ActiveRecord::Base  
  self.per_page = 15
  
  validates :title, :description, :presence => true  
  attr_accessible :description, :software, :software_id, :title, :type, :user, :user_id, :reporter_name, :reporter_email
  
  belongs_to :user
  belongs_to :software
  has_many :messages

  set_inheritance_column :inhet_type
  
  TYPES = [['Bug', 1], 
           ['Request', 2],
           ['Enhancement', 3],
           ['Duplicate', 4],
           ['Cant reproduce', 5]]
  
  
  def self.type_named(name)
    TYPES.select { |t| t[0]==name }.flatten[1]
  end
  
  def human_readable_type
    TYPES.select { |t| t[1]==type }.flatten.first
  end
  
  def self.type_with_id(id)
    TYPES.select { |t| t[1]==id }.flatten.first
  end
  
  def user
    User.find(user_id) if user_id
  end
  
  def software
    Software.find(software_id)
  end
  
end
