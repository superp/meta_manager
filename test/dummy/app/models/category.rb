class Category < ActiveRecord::Base
  include MetaManager::Taggable
  
  attr_accessible :title
  
  validates_presence_of :title
end
