require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get quantity_total" do
    get pages_quantity_total_url
    assert_response :success
  end

  test "should get index" do
    get pages_index_url
    assert_response :success
  end
end
