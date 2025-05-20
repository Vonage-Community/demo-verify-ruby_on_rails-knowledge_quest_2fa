class Session < ApplicationRecord
  belongs_to :user
  has_many :otp_verifications, dependent: :delete_all
end
