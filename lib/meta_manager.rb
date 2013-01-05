require 'active_support/concern'
require 'orm_adapter'

module MetaManager
  autoload :Taggable, "meta_manager/taggable"
  autoload :Helper, "meta_manager/helper"
  autoload :Model, "meta_manager/model"
end

require 'meta_manager/engine'
