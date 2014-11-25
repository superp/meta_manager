module MetaManager
  module Helper
    include ::ActionView::Helpers::TagHelper
    
    def self.included(base)
      base.send :helper_method, :render_meta_tags, :render_page_title
    end
    
    def render_meta_tags(record)
      return if record.nil?
      
      dynamic = self.instance_variable_get("@meta_dynamic")
      tags = []
      
      get_actual_meta_tags(record, dynamic).each do |meta_tag|
        unless meta_tag.name == 'title'
          type = meta_tag.name =~ /og:/ ? 'property' : 'name'
          tags << tag(:meta, type => meta_tag.name, :content => meta_tag.get_content(self))
        end
      end
      
      tags.join("\n\s\s")
    end
    
    def render_page_title(record=nil, options = {})
      dynamic = self.instance_variable_get("@meta_dynamic")
      
      meta_tags = get_actual_meta_tags(record, dynamic)    
      meta_tags.detect{|t| t.name == 'title'}.try(:get_content, self) || get_page_title(record, options)
    end
    
    private
      
      def get_page_title(record, options)
        options = { :spliter => ' - ', :append_title => true }.merge(options)
        
        view_title = record.respond_to?(:title) ? record.title : (record.respond_to?(:name) ? record.name : nil) unless record.nil?
        
        page_title = []
        page_title << options[:title] if options.key?(:title)
        page_title << view_title unless record.nil?
        page_title << I18n.t("page.title") if options[:append_title]

        page_title.flatten.compact.uniq.join(options[:spliter])
      end
      
      def get_actual_meta_tags(record, dynamic)
        meta_tags = []
        _meta_tags = record && record.respond_to?(:meta_tags) ? record.meta_tags : []
        
        _meta_tags.group_by(&:name).each do |name, items|
          meta_tags << (items.detect{|r| r.is_dynamic && dynamic} || items.detect{|r| !r.is_dynamic})
        end
        
        meta_tags.compact
      end
  end
end
