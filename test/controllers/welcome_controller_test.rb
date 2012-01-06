require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  
  test "should get index without category" do
    get :index
    assert_response :success
  end
  
end
