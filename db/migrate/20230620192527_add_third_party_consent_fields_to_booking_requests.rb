class AddThirdPartyConsentFieldsToBookingRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :booking_requests, :data_subject_consent_obtained, :boolean, null: false, default: false
    add_column :booking_requests, :printed_consent_form_required, :boolean, null: false, default: false
    add_column :booking_requests, :power_of_attorney, :boolean, null: false, default: false
    add_column :booking_requests, :email_consent_form_required, :boolean, null: false, default: false

    add_column :booking_requests, :data_subject_name, :string, null: false, default: ''
    add_column :booking_requests, :consent_address_line_one, :string, null: false, default: ''
    add_column :booking_requests, :consent_address_line_two, :string, null: false, default: ''
    add_column :booking_requests, :consent_address_line_three, :string, null: false, default: ''
    add_column :booking_requests, :consent_town, :string, null: false, default: ''
    add_column :booking_requests, :consent_county, :string, null: false, default: ''
    add_column :booking_requests, :consent_postcode, :string, null: false, default: ''
    add_column :booking_requests, :email_consent, :string, null: false, default: ''

    add_column :booking_requests, :data_subject_date_of_birth, :date, null: true
  end
end
