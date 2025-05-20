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
        send_otp_to_user(verification)
      end
    end

    def send_otp_to_user(verification)
      verification_workflow = [{ channel: 'sms', to: Current.user.phone_number }]

      begin
        response = Vonage.verify2.start_verification(brand: 'Vonage', workflow: verification_workflow)
        verification.update!(request_id: response.request_id)
      rescue Vonage::Error => error
        logger.debug error.http_response_code
        logger.debug error.http_response_body
      end
    end

    def check_otp(verification_request_id:, otp:)
      response = begin
        Vonage.verify2.check_code(
          request_id: verification_request_id,
          code: otp
        )
      rescue Vonage::Error => error
        error
      end
      response.http_response.code
    end

    def otp_valid?(otp_check)
      otp_check == "200"
    end

    def invalid_otp_response_message(otp_check)
      case otp_check
      when '400'
        'The code you entered is invalid.'
      when '404'
        'The code you entered has expired.'
      when '410'
        'You have reached the maximum number of attempts.'
      else
        'Sorry, something went wrong. Please try again later.'
      end
    end
end