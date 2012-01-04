require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  
  setup do
    @category = Category.new :title => 'Test category'
    
    @category.tag_title = 'test title'
    @category.tag_keywords = 'test, keywords'
    @category.tag_description = 'test description'
    
    @category.meta_tags.build(:name => "og:title", :content => 'category og:title')
    @category.meta_tags.build(:name => "title", :content => 'title %{post.title}, content %{post.content}, notes %{post.notes}', :is_dynamic => true)
    @category.meta_tags.build(:name => "og:title", :content => 'dynamic og:title - %{post.title}', :is_dynamic => true)
    
    @category.save
    
    @post = Post.create(:title => 'test_title', :content => 'test_content', :notes => 'test_notes')
  end  
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end
  
  test "should get show" do
    get :show, :id => 1
    assert_response :success
    assert_not_nil assigns(:post)
  end
  
  
  
  test "should have meta tags at index action" do
    get :index
    
    assert_select 'title', {:count => 1, :text => "test title"}
    
    assert_select "meta[name=keywords]", {:count => 1} do
      assert_select "[content=?]", 'test, keywords'
    end
    
    assert_select "meta[name=description]", {:count => 1} do
      assert_select "[content=?]", 'test description'
    end
    
    assert_select "meta[property=og:title]", {:count => 1} do
      assert_select "[content=?]", 'category og:title'
    end
  end
  
  
  
  test "should have dynamic meta tags at show action" do
    get :show, :id => 1
    
    assert_select 'title', {:count => 1, :text => "title test_title, content test_content, notes test_notes"}
    
    assert_select "meta[name=keywords]", {:count => 1} do
      assert_select "[content=?]", 'test, keywords'
    end
    
    assert_select "meta[name=description]", {:count => 1} do
      assert_select "[content=?]", 'test description'
    end
    
    assert_select "meta[property=og:title]", {:count => 1} do
      assert_select "[content=?]", 'dynamic og:title - test_title'
    end
  end
end
