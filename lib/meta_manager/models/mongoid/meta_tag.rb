require 'mongoid'

class MetaTag
  include Mongoid::Document
  include Mongoid::Timestamps
  include MetaManager::Model

  # Columns
  field :name, :type => String
  field :content, :type => String
  field :is_dynamic, :type => Boolean

  index({:name => 1})

  belongs_to :taggable, :polymorphic => true, :index => true
end