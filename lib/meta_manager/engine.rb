require 'rails'
require 'meta_manager'

module MetaManager #:nodoc:
  class Engine < ::Rails::Engine #:nodoc:
    initializer 'meta_manager.setup' do
      ActiveSupport.on_load :action_controller do
        ActionController::Base.send :include, MetaManager::Helper
      end
    end
  end
end
