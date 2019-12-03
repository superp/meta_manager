module MetaManager
  module Taggable
    extend ::ActiveSupport::Concern

    included do |base|
      has_many :meta_tags, as: :taggable, dependent: :destroy, autosave: true

      accepts_nested_attributes_for :meta_tags, reject_if: proc { |tag| tag['content'].blank? }, allow_destroy: true

      # alias_method_chain :respond_to?, :tags
      # alias_method_chain :method_missing, :tags
      base.prepend Extension
    end

    # some required extentions
    module Extension
      def respond_to?(method_sym, include_all = false)
        return true if method_sym.to_s =~ meta_match_case

        super
      end

      def method_missing(method_name, *args)
        key = method_name.to_s

        if key =~ meta_match_case
          attr_name = key.gsub(meta_match_case, '')

          if key =~ /=$/ && !args.first.blank?
            record = meta_tag(attr_name, build: true)
            record.content = args.first
          else
            meta_tag(attr_name).try(:content)
          end
        else
          super
        end
      end
    end

    # Save meta tags records into one hash
    def meta_tag(attr_name, options = {})
      key = normalize_meta_tag_name(attr_name)

      cached_meta_tags[key] ||= meta_tags.detect { |t| t.name == key }
      cached_meta_tags[key] ||= meta_tags.build(name: key) if options[:build]
      cached_meta_tags[key]
    end

    def cached_meta_tags
      @cached_meta_tags ||= {}
    end

    protected

    def normalize_meta_tag_name(value)
      value.to_s.downcase.strip.gsub('_before_type_cast', '').gsub(/=$/, '')
    end

    def meta_match_case
      /^tag_/
    end
  end
end
