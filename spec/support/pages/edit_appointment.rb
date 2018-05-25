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

    element :date, '.t-date'
    element :time_hour, '#appointment_proceeded_at_4i'
    element :time_minute, '#appointment_proceeded_at_5i'

    element :slot_one_date,     '.t-slot-1-date'
    element :slot_one_period,   '.t-slot-1-period'
    element :slot_two_date,     '.t-slot-2-date'
    element :slot_two_period,   '.t-slot-2-period'
    element :slot_three_date,   '.t-slot-3-date'
    element :slot_three_period, '.t-slot-3-period'

    element :submit, '.t-submit'

    element :postal_address, '.t-postal-address'
    element :edit_postal_address, '.t-edit-postal-address'

    element :status, '.t-status'

    elements :errors, '.field_with_errors'
    element :error_summary, '.t-errors'

    section :activity_feed, Sections::ActivityFeed, '.t-activity-feed'
  end
end
