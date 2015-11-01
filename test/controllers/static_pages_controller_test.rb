require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test 'home page' do
    get :index
    assert_response :success
  end
end
