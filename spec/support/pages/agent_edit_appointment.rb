require_relative '../sections/activity'
require_relative '../sections/activity_feed'

module Pages
  class AgentEditAppointment < SitePrism::Page
    set_url '/agents/appointments/{id}/edit'

    element :name, '.t-name'
    element :email, '.t-email'
    element :phone, '.t-phone'
    element :memorable_word, '.t-memorable-word'
    element :day_of_birth, '.t-date-of-birth-day'
    element :month_of_birth, '.t-date-of-birth-month'
    element :year_of_birth, '.t-date-of-birth-year'
    element :accessibility_requirements, '.t-accessibility-requirements'
    element :additional_information, '.t-additional-info'
    element :defined_contribution_pot_confirmed_yes, '.t-defined-contribution-pot-confirmed-yes'
    element :defined_contribution_pot_confirmed_dont_know, '.t-defined-contribution-pot-confirmed-dont-know'
    element :gdpr_consent_yes, '.t-gdpr-consent-yes'
    element :gdpr_consent_no, '.t-gdpr-consent-no'
    element :gdpr_consent_no_response, '.t-gdpr-consent-no-response'
    element :bsl, '.t-bsl-video'

    element :third_party, '.t-third-party'
    element :data_subject_name, '.t-data-subject-name'
    element :data_subject_date_of_birth, '.t-data-subject-date-of-birth'
    element :data_subject_consent_obtained, '.t-data-subject-consent-obtained'
    element :power_of_attorney, '.t-power-of-attorney'
    element :printed_consent_form_required, '.t-printed-consent-form-required'
    element :consent_address_line_one, '.t-consent-address-line-one'
    element :consent_address_line_two, '.t-consent-address-line-two'
    element :consent_address_line_three, '.t-consent-address-line-three'
    element :consent_address_town, '.t-consent-town'
    element :consent_address_county, '.t-consent-county'
    element :consent_address_postcode, '.t-consent-postcode'
    element :printed_consent_form_postcode_lookup, '.t-printed-consent-form-postcode-lookup'
    element :email_consent_form_required, '.t-email-consent-form-required'
    element :email_consent, '.t-email-consent'

    element :submit, '.t-submit'
    element :resend_confirmation, '.t-resend-confirmation'
    element :cancel, '.t-cancel'

    elements :errors, '.field_with_errors'
    element :error_summary, '.t-errors'
    element :success, '.alert-success'
    element :location, '.t-location-name'
    element :booking_location, '.t-booking-location'

    section :activity_feed, Sections::ActivityFeed, '.t-activity-feed'
  end
end
