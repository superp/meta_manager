class MetaTag < ::ActiveRecord::Base
  belongs_to :taggable, :polymorphic => true
  
  validates_presence_of :name, :taggable_type
  validates_uniqueness_of :name, :scope => [:taggable_type, :taggable_id]
  
  attr_accessible :name, :content, :is_dymanic
end
