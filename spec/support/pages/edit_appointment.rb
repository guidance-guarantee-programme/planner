require_relative '../sections/activity'
require_relative '../sections/activity_feed'

module Pages
  class EditAppointment < SitePrism::Page
    set_url '/appointments/{id}/edit'

    element :name, '.t-name'
    element :email, '.t-email'
    element :phone, '.t-phone'
    element :memorable_word, '.t-memorable-word'
    element :location, '.t-location'
    element :guider, '.t-guider'
    element :day_of_birth, '.t-date-of-birth-day'
    element :month_of_birth, '.t-date-of-birth-month'
    element :year_of_birth, '.t-date-of-birth-year'
    element :accessibility_requirements, '.t-accessibility-requirements'
    element :defined_contribution_pot_confirmed_yes, '.t-defined-contribution-pot-confirmed-yes'
    element :defined_contribution_pot_confirmed_dont_know, '.t-defined-contribution-pot-confirmed-dont-know'
    element :gdpr_consent, '.t-gdpr-consent'
    element :consent, '.t-consent-button'
    element :bsl, '.t-bsl-video'
    element :welsh, '.t-welsh'
    element :third_party, '.t-third-party'
    element :data_subject_name, '.t-data-subject-name'
    element :data_subject_date_of_birth, '.t-data-subject-date-of-birth'

    element :date, '.t-date'
    element :time_hour, '#appointment_proceeded_at_4i'
    element :time_minute, '#appointment_proceeded_at_5i'

    element :slot_one_date,     '.t-slot-1-date'
    element :slot_one_period,   '.t-slot-1-period'
    element :slot_two_date,     '.t-slot-2-date'
    element :slot_two_period,   '.t-slot-2-period'
    element :slot_three_date,   '.t-slot-3-date'
    element :slot_three_period, '.t-slot-3-period'

    element :process, '.t-process'
    element :submit, '.t-submit'
    element :resend_confirmation, '.t-resend-confirmation'
    element :reschedule, '.t-reschedule-button'

    element :postal_address, '.t-postal-address'
    element :edit_postal_address, '.t-edit-postal-address'

    element :status, '.t-status'
    element :secondary_status, '.t-secondary-status'
    elements :secondary_status_options, '.t-secondary-status > option:not(:empty)'

    element :attended_digital_yes, '.t-attended-digital-yes'

    elements :errors, '.field_with_errors'
    element :error_summary, '.t-errors'
    element :success, '.alert-success'

    elements :duplicates, '.t-duplicate'

    section :activity_feed, Sections::ActivityFeed, '.t-activity-feed'

    section :rescheduling_modal, '.t-rescheduling-modal' do
      element :slot, '.t-slot'
      element :reschedule, '.t-reschedule'
    end

    section :consent_modal, '.t-consent-modal' do
      element :consent_yes, '.t-consent-yes'
      element :consent_no, '.t-consent-no'
      element :consent_no_response, '.t-consent-no-response'
      element :update, '.t-consent'
    end
  end
end
