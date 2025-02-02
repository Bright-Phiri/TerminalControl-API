require "test_helper"

class TerminalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get terminals_index_url
    assert_response :success
  end
end
