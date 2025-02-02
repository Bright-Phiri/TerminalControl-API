require "test_helper"

class Controllers::Api::V1::TerminalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get controllers_api_v1_terminals_index_url
    assert_response :success
  end
end
