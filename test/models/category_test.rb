require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  setup do
    @category = Category.new :title => 'Test category'
  end  
  
  test "truth" do
    assert_kind_of Class, Category
  end
  
  test "should save meta tags with new_record" do
    value = "title content"
    @category.tag_title = value
    
    assert_equal @category.meta_tag(:title).content, value
    assert_equal @category.meta_tag(:keywords).try(:content), nil
    
    assert_difference('MetaTag.count', 1) do
      @category.save
    end
  end
  
  test "should load meta tags into record" do
    @category.tag_title = "title content"
    @category.tag_keywords = "keywords content"
    @category.save
    
    @category.reload
    
    assert_equal @category.tag_title, "title content"
    assert_equal @category.tag_keywords, "keywords content"
  end
  
  test "should raise error on not valid meta tag method" do
    assert_raise(NoMethodError) do
      @category.tagg_method
    end
  end
  
  test 'should be work with respond_to method' do
    assert @category.respond_to?(:tag_title)
    assert !@category.respond_to?(:tagg_title)
    assert_respond_to(@category, :tag_title)
  end
  
  test 'should not save tag without content' do    
    @category.tag_title = ''
    @category.save
    
    @category.reload
    
    assert_equal @category.meta_tags.count, 0
    assert_equal @category.tag_title, nil
    assert_equal @category.meta_tag(:title).try(:content), nil
  end
end
