module MetaManager
  module Model
    extend ::ActiveSupport::Concern

    included do
      validates_presence_of :name, :taggable_type
      validates_uniqueness_of :name, scope: %i[taggable_type taggable_id is_dynamic]
      validates :content, length: { maximum: 4000 }
    end

    def get_content(controller = nil)
      is_dynamic ? dynamic_content(controller) : content
    end

    def dynamic_content(controller)
      content.gsub /%{([\w\.]+)}/ do
        items = $1.split('.')
        instance_name = items.shift
        method_name = items.join('.')
        record = controller.instance_variable_get("@#{instance_name}")

        record.try(:"#{method_name}")
      end
    end
  end
end
