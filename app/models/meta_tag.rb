class MetaTag < ::ActiveRecord::Base
  belongs_to :taggable, :polymorphic => true
  
  validates_presence_of :name, :taggable_type
  validates_uniqueness_of :name, :scope => [:taggable_type, :taggable_id, :is_dynamic]
  
  attr_accessible :name, :content, :is_dynamic
  
  def get_content(controller=nil)
    self.is_dynamic ? dynamic_content(controller) : self.content
  end
  
  def dynamic_content(controller)
    self.content.gsub /%{([\w\.]+)}/ do
      items = $1.split('.')
      instance_name = items.shift
      method_name = items.join('.')
      record = controller.instance_variable_get("@#{instance_name}")

      record.try(:"#{method_name}")
    end
  end
end
