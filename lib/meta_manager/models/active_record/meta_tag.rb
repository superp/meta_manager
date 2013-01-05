class MetaTag < ::ActiveRecord::Base
  include MetaManager::Model

  belongs_to :taggable, :polymorphic => true
  
  validates_presence_of :name, :taggable_type, :content
  validates_uniqueness_of :name, :scope => [:taggable_type, :taggable_id, :is_dynamic]
end