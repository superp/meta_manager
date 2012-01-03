class Category < ActiveRecord::Base
  include MetaManager::Taggable
  
  validates_presence_of :title
end
