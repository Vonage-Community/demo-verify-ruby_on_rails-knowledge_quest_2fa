class OtpVerificationsController < ApplicationController
  include TwoFactorAuthentication
  allow_two_factor_unauthenticated_access only: %i[ edit update ]
  def edit
    @otp_verification = find_last_otp_verification
    @otp_verification ||= start_new_otp_verification_for_session
  end

  def update
    otp_verification = OtpVerification.find(params[:id])
    otp_check = check_otp(
      verification_request_id: otp_verification.request_id,
      otp: params[:otp]
    )
    if otp_valid?(otp_check)
      otp_verification.update!(verified: true, verified_at: Time.current)
      redirect_to after_authentication_url
    else
      alert_text = invalid_otp_response_message(otp_check)
      redirect_to edit_otp_verification_path(otp_verification), alert: alert_text
    end
  end
end
