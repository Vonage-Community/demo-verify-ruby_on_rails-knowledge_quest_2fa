class CreateOtpVerifications < ActiveRecord::Migration[8.0]
  def change
    create_table :otp_verifications do |t|
      t.references :session, null: false, foreign_key: true
      t.string :request_id
      t.boolean :verified
      t.datetime :verified_at

      t.timestamps
    end
  end
end
