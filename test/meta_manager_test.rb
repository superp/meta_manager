require 'test_helper'

class MetaManagerTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, MetaManager
  end
  
  test 'shound be included by Category instance' do
    assert Category.new.respond_to?(:meta_tags)
  end
end
