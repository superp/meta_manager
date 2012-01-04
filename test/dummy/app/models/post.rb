class Post < ActiveRecord::Base  
  validates_presence_of :title
  
  attr_accessible :title, :content, :notes
end
