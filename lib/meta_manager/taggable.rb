module MetaManager
  module Taggable
    extend ::ActiveSupport::Concern

    included do
      has_many :meta_tags, :as => :taggable, :dependent => :destroy, :autosave => true

      accepts_nested_attributes_for :meta_tags, :reject_if => proc { |tag| tag['content'].blank? }, :allow_destroy => true

      alias_method_chain :respond_to?, :tags
      alias_method_chain :method_missing, :tags
    end

    # Save meta tags records into one hash
    def meta_tag(attr_name, options={})
      key = normalize_meta_tag_name(attr_name)

      cached_meta_tags[key] ||= self.meta_tags.detect {|t| t.name == key}
      cached_meta_tags[key] ||= self.meta_tags.build(:name => key) if options[:build]
      cached_meta_tags[key]
    end

    def cached_meta_tags
      @cached_meta_tags ||= {}
    end

    def respond_to_with_tags?(method_sym, include_all = false)
      return true if method_sym.to_s =~ meta_match_case
      respond_to_without_tags?(method_sym, include_all)
    end

    protected

      def method_missing_with_tags(method_name, *args)
        key = method_name.to_s

        if key =~ meta_match_case
          attr_name = key.gsub(meta_match_case, '')

          if key =~ /=$/ && !args.first.blank?
            record = meta_tag(attr_name, :build => true)
            record.content = args.first
          else
            meta_tag(attr_name).try(:content)
          end
        else
          return method_missing_without_tags(method_name, *args)
        end
      end

      def normalize_meta_tag_name(value)
        value.to_s.downcase.strip.gsub("_before_type_cast", '').gsub(/=$/, '')
      end

      def meta_match_case
        /^tag_/
      end
  end
end
