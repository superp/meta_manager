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
          tags << tag(:meta, type => meta_tag.name, :content => render_meta_tag_content(meta_tag))
        end
      end

      tags.join("\n\s\s")
    end

    def render_page_title(record=nil, options = {})
      dynamic = self.instance_variable_get("@meta_dynamic")

      meta_tags = get_actual_meta_tags(record, dynamic)
      meta_tags.detect{|t| t.name == 'title'}.try(:get_content, self) || get_page_title(record, options)
    end

    protected

    # Call render_meta_tag_content_description if method exists
    # Controller:
    #  protected
    #
    #   def render_meta_tag_content_description(meta_tag)
    #      if !params[:page].blank? && params[:page] != '1'
    #        meta_tag.content += " - page #{params[:page].to_i}"
    #      end
    #   end
    #
    def render_meta_tag_content(meta_tag)
      method_name = "render_meta_tag_content_#{meta_tag.name}".to_sym
      send(method_name, meta_tag) if respond_to?(method_name, true)

      meta_tag.get_content(self)
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
