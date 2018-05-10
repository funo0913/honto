require 'test_helper'

class RecommendControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recommend_index_url
    assert_response :success
  end

end
