module Pages
  class AdHocBooking < SitePrism::Page
    set_url '/locations/{location_id}/appointments/new'

    element :errors, '.t-errors'

    element :availability_calendar, '.t-availability-calendar-on'
    element :ad_hoc_calendar, '.t-availability-calendar-off'
    element :ad_hoc_start_at, '.t-ad-hoc-start-at'
    element :guider, '.t-guider'

    element :first_choice_slot, '.t-first-choice-slot'

    element :name, '.t-name'
    element :phone, '.t-phone'
    element :memorable_word, '.t-memorable-word'
    element :date_of_birth, '.t-date-of-birth'
    element :accessibility_requirements, '.t-accessibility-requirements'
    element :gdpr_consent_yes, '.t-gdpr-consent-yes'
    element :gdpr_consent_no, '.t-gdpr-consent-no'
    element :gdpr_consent_no_response, '.t-gdpr-consent-no-response'
    element :defined_contribution_pot_confirmed_yes, '.t-defined-contribution-pot-confirmed-yes'
    element :defined_contribution_pot_confirmed_dont_know, '.t-defined-contribution-pot-confirmed-dont-know'
    element :where_you_heard, '.t-where-you-heard'

    element :email, '.t-email'
    element :address_line_one, '.t-address-line-one'
    element :address_line_two, '.t-address-line-two'
    element :address_line_three, '.t-address-line-three'
    element :town, '.t-town'
    element :county, '.t-county'
    element :postcode, '.t-postcode'
    element :country, '.t-country'
    element :additional_info, '.t-additional-info'
    element :bsl, '.t-bsl-video'

    element :third_party, '.t-third-party'
    element :data_subject_name, '.t-data-subject-name'
    element :data_subject_date_of_birth, '.t-data-subject-date-of-birth'
    element :data_subject_consent_obtained, '.t-data-subject-consent-obtained'
    element :power_of_attorney, '.t-power-of-attorney'
    element :printed_consent_form_required, '.t-printed-consent-form-required'
    element :printed_consent_form_postcode_lookup, '.t-printed-consent-form-postcode-lookup'
    element :email_consent_form_required, '.t-email-consent-form-required'
    element :email_consent, '.t-email-consent'

    element :preview, '.t-preview'
  end
end
