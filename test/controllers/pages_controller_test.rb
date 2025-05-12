require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  test "should get authenticated" do
    get pages_authenticated_url
    assert_response :success
  end

  test "should get two_factor_authenticated" do
    get pages_two_factor_authenticated_url
    assert_response :success
  end
end
