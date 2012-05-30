module MetaManager
  module Taggable
    extend ::ActiveSupport::Concern
    
    included do          
      has_many :meta_tags, :as => :taggable, :dependent => :destroy, :autosave => true
        
      accepts_nested_attributes_for :meta_tags, :reject_if => :all_blank, :allow_destroy => true
    end
    
    # Find meta tag by name or build new record
    def find_or_build_meta_tag(attr_name)
      key = normalize_meta_tag_name(attr_name)
      self.meta_tags.where(:name => key).first || self.meta_tags.build(:name => key)
    end
    
    # Save meta tags records into one hash
    def meta_tag(attr_name)
      key = normalize_meta_tag_name(attr_name)
      @meta_tag ||= {}
      @meta_tag[key] ||= find_or_build_meta_tag(key)
    end
    
    def respond_to?(method_sym, include_private = false)
      if method_sym.to_s =~ meta_match_case
        true
      else
        super
      end
    end
    
    protected
    
    def normalize_meta_tag_name(value)
      value.to_s.downcase.strip
    end
    
    def method_missing(method, *args, &block)
      key = method.to_s
      
      if key =~ meta_match_case
        attr_name = key.gsub(meta_match_case, '')
        
        if key =~ /=$/
          record = meta_tag(attr_name.chop)
          record.content = args.first
        else 
          meta_tag(attr_name).try(:content)
        end
      else
        super
      end
    end
    
    def meta_match_case
      /^tag_/
    end
  end
end
