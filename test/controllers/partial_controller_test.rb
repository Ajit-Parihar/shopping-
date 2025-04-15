require "test_helper"

class PartialControllerTest < ActionDispatch::IntegrationTest
  test "should get quantity_total" do
    get partial_quantity_total_url
    assert_response :success
  end
end
