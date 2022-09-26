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

    element :submit, '.t-submit'
    element :resend_confirmation, '.t-resend-confirmation'

    elements :errors, '.field_with_errors'
    element :error_summary, '.t-errors'
    element :success, '.alert-success'
    element :location, '.t-location-name'
    element :booking_location, '.t-booking-location'

    section :activity_feed, Sections::ActivityFeed, '.t-activity-feed'
  end
end
