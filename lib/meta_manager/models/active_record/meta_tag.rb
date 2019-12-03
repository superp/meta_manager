class MetaTag < ::ActiveRecord::Base
  include MetaManager::Model

  belongs_to :taggable, polymorphic: true

  validates_presence_of :name, :taggable_type
  validates_uniqueness_of :name, scope: %i[taggable_type taggable_id is_dynamic]
end
