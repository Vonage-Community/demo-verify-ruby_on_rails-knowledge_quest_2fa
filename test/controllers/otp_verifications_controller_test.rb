require "test_helper"

class OtpVerificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get otp_verifications_edit_url
    assert_response :success
  end

  test "should get update" do
    get otp_verifications_update_url
    assert_response :success
  end
end
