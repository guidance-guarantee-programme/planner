class AddGdprConsentToBookingRequests < ActiveRecord::Migration[5.1]
  def up
    add_column :booking_requests, :gdpr_consent, :string, null: false, default: ''

    BookingRequest.reset_column_information

    BookingRequest.where(marketing_opt_in: true).update_all(gdpr_consent: 'yes')
    BookingRequest.where(marketing_opt_in: false).update_all(gdpr_consent: 'no')

    remove_column :booking_requests, :marketing_opt_in
  end

  def down
    add_column :booking_requests, :marketing_opt_in, :boolean, null: false, default: false

    BookingRequest.reset_column_information

    BookingRequest.where(gdpr_consent: ['yes', '']).update_all(marketing_opt_in: true)
    BookingRequest.where(gdpr_consent: 'no').update_all(marketing_opt_in: false)

    remove_column :booking_requests, :gdpr_consent
  end
end
