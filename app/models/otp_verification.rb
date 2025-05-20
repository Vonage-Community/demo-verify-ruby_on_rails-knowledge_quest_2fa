class OtpVerification < ApplicationRecord
  belongs_to :session

  def verified?
    self.verified
  end
end
