require "test_helper"

class TaxpayersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get taxpayers_index_url
    assert_response :success
  end

  test "should get create" do
    get taxpayers_create_url
    assert_response :success
  end
end
