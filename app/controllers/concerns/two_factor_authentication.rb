module TwoFactorAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :require_two_factor_authentication
    helper_method :two_factor_authenticated?
  end

  class_methods do
    def allow_two_factor_unauthenticated_access(**options)
      skip_before_action :require_two_factor_authentication, **options
    end
  end

  private
    def two_factor_authenticated?
      current_otp_verification
    end

    def require_two_factor_authentication
      require_authentication && current_otp_verification || request_otp_verification
    end

    def current_otp_verification
      verification = find_last_otp_verification
      verification&.verified?
    end

    def find_last_otp_verification
      Current.session.otp_verifications.last
    end

    def request_otp_verification
      session[:return_to_after_authenticating] = request.url
      verification = start_new_otp_verification_for_session
      redirect_to edit_otp_verification_path(verification)
    end

    def start_new_otp_verification_for_session
      Current.session.otp_verifications.create!.tap do |verification|
        # send_otp_to_user
      end
    end

    def check_otp(verification_request_id:, otp:)
      # Check the OTP against the verification request
      # This is a placeholder for the actual OTP checking logic
      # In a real application, you would integrate with an OTP service here
      "200"
    end

    def otp_valid?(otp_check)
      otp_check == "200"
    end

    def invalid_otp_response_message(otp_check)
      # Generate an error message based on the OTP check result
      # This is a placeholder for the actual error message generation logic
      "Invalid OTP. Please try again."
    end
end