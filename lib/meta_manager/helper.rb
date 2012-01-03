module MetaManager
  module Helper
    #extend ::ActionView::Helpers::TagHelper
    
    def self.included(base)
      base.send :helper_method, :render_meta_tags, :render_title
    end
    
    def render_meta_tags(record, options = {})
      return if record.nil?
     
      tags = []
      
      _meta_tags = record.respond_to?(:meta_tags) ? record.meta_tags : []
      
      _meta_tags.each do |meta_tag|
        tags << tag(:meta, :content => meta_tag.get_content(controller), :name => meta_tag.name)
      end
      
      tags.join("\n")
    end
    
    def render_title(record=nil, options = {})      
      @page_title = record.try(:meta_tags).try(:detect, {|t| t.name == 'title'}).try(:content) || get_page_title(record, options)
    end
    
    private
      
      def get_page_title(record, options)
        options = { :spliter => ' – ', :append_title => true }.merge(options)
        
        view_title = if record.respond_to?(:title)
          record.title
        elsif record.respond_to(:name)
          record.name
        end
        
        page_title = []
        page_title << options[:title] if options.key?(:title)
        page_title << view_title
        page_title << I18n.t("page.title") if options[:append_title]

        page_title.flatten.compact.uniq.join(options[:spliter])
      end
  end
end
