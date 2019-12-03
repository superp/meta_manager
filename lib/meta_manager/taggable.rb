module MetaManager
  module Taggable
    extend ::ActiveSupport::Concern

    included do |base|
      has_many :meta_tags, as: :taggable, dependent: :destroy, autosave: true

      accepts_nested_attributes_for :meta_tags, reject_if: proc { |tag| tag['content'].nil? }, allow_destroy: true

      # alias_method_chain :respond_to?, :tags
      # alias_method_chain :method_missing, :tags
      base.prepend Extension
    end

    # some required extentions
    module Extension
      def respond_to_missing?(method_sym, include_all = false)
        return true if method_sym.to_s =~ meta_match_case

        super
      end

      def method_missing(method_sym, *args)
        key = method_sym.to_s
        return read_or_update(key, args.first) if key =~ meta_match_case

        super
      end
    end

    # Save meta tags records into one hash
    def meta_tag(attr_name, options = {})
      key = normalize_meta_tag_name(attr_name)

      key = localized_key(key)

      cached_meta_tags[key] ||= find_meta(key, options[:fallback])
      cached_meta_tags[key] ||= meta_tags.build(name: key) if options[:build]

      cached_meta_tags[key]
    end

    def cached_meta_tags
      @cached_meta_tags ||= {}
    end

    protected

    def find_meta(key, fallback = false)
      found = meta_tags.detect { |t| t.name == key }
      return found unless fallback

      fallback_keys(key).each do |alter_key|
        found ||= meta_tags.detect { |t| t.name == alter_key } if fallback

        break if found
      end

      found
    end

    def fallback_keys(key)
      pure_key = key.gsub(/_(#{I18n.available_locales.join('|')})$/, '')
      [
        key,
        "#{pure_key}_#{I18n.default_locale}",
        pure_key
      ].compact
    end

    def read_or_update(key, value = nil)
      attr_name = key.gsub(meta_match_case, '')
      return find_tag_content(attr_name) if value.nil? || key =~ /[^=]$/

      record = meta_tag(attr_name, build: value.present?, fallback: value.blank?)
      return if record.blank?
      return record.delete if value.blank?

      record.content = value
    end

    def normalize_meta_tag_name(value)
      value.to_s.downcase.strip.gsub('_before_type_cast', '').gsub(/=$/, '')
    end

    def meta_match_case
      /^tag_/
    end

    def localized_meta_key_case
      /^(.+?)(?:_(#{I18n.available_locales.join('|')}))?$/
    end

    def localized_key(key)
      key, locale = localized_meta_key_case.match(key)[1..2]
      [key, locale || I18n.locale].join('_')
    end

    def find_tag_content(attr_name)
      meta_tag(attr_name, fallback: true).try(:content)
    end
  end
end
