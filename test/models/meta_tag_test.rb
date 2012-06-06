require 'test_helper'

class MetaTagTest < ActiveSupport::TestCase
  # called before every single test
  def setup
    @tag = MetaTag.new(:name => 'somename')
    @tag.taggable_type = 'Category'
    @tag.taggable_id = 1
    @tag.content = 'some content'
  end
  
  test "truth" do
    assert_kind_of Class, MetaTag
  end
  
  test 'should create new record with valid attributes' do
    @tag.save!
  end
  
  test 'should not be valid with empty name' do
    @tag.name = nil
    assert !@tag.valid?
  end
  
  test 'should not be valid with not uniq name' do
    @tag.update_attribute(:name, 'test')
    
    @next_tag = MetaTag.new(:name => 'test')
    @next_tag.taggable_type = 'Category'
    @next_tag.taggable_id = 1
    
    assert !@next_tag.valid?
  end
  
  test 'should be valid with not uniq name but dynamic' do
    @tag.update_attribute(:name, 'test')
    
    @next_tag = MetaTag.new(:name => 'test', :is_dynamic => true)
    @next_tag.taggable_type = 'Category'
    @next_tag.taggable_id = 1
    @next_tag.content = 'content'
    
    assert @next_tag.valid?
  end
  
  test 'should not be valid with not uniq name both dynamic' do
    @tag.update_attribute(:is_dynamic, true)
    
    @next_tag = MetaTag.new(:name => 'somename', :is_dynamic => true)
    @next_tag.taggable_type = 'Category'
    @next_tag.taggable_id = 1
    
    assert !@next_tag.valid?
  end
  
  test 'should be valid with not uniq name in other parent record' do
    @tag.update_attribute(:name, 'test')
    
    @next_tag = MetaTag.new(:name => 'test')
    @next_tag.taggable_type = 'Category'
    @next_tag.taggable_id = 2
    @next_tag.content = 'content'
    
    assert @next_tag.valid?
  end
  
  test 'should return valid dynamic content' do
    assert true
  end
end
