require_relative '../sections/activity'
require_relative '../sections/activity_feed'

module Pages
  class FulfilBookingRequest < SitePrism::Page
    set_url '/booking_requests/{booking_request_id}/appointments/new'

    element :name, '.t-name'
    element :reference, '.t-reference'
    element :phone, '.t-phone'
    element :email, '.t-email'
    element :location_name, '.t-location-name'
    element :memorable_word, '.t-memorable-word'
    element :age_range, '.t-age-range'
    element :day_of_birth, '.t-date-of-birth-day'
    element :additional_info, '.t-additional-info'
    element :month_of_birth, '.t-date-of-birth-month'
    element :year_of_birth, '.t-date-of-birth-year'
    element :accessibility_requirements, '.t-accessibility-requirements'
    element :defined_contribution_pot_confirmed_yes, '.t-defined-contribution-pot-confirmed-yes'
    element :defined_contribution_pot_confirmed_dont_know, '.t-defined-contribution-pot-confirmed-dont-know'
    element :gdpr_consent, '.t-gdpr-consent'

    element :slot_one_date,     '.t-slot-1-date'
    element :slot_one_period,   '.t-slot-1-period'
    element :slot_two_date,     '.t-slot-2-date'
    element :slot_two_period,   '.t-slot-2-period'
    element :slot_three_date,   '.t-slot-3-date'
    element :slot_three_period, '.t-slot-3-period'

    element :guider, '.t-guider'

    element :location, '.t-location'

    element :date,        '.t-date'
    element :time_hour,   '#appointment_time_4i'
    element :time_minute, '#appointment_time_5i'

    element :change_booking_state, '.t-booking-request-change-state-button'
    element :resend_confirmation, '.t-resend-confirmation'

    element :booking_request_active_status, '.t-booking-request-active-status'
    element :booking_request_awaiting_customer_status, '.t-booking-request-awaiting-customer-feedback-status'
    element :booking_request_hidden_status, '.t-booking-request-hidden-status'
    element :submit_booking_request, '.t-submit-booking-request'
    element :submit_appointment, '.t-submit-appointment'

    element :postal_address, '.t-postal-address'
    element :edit_postal_address, '.t-edit-postal-address'

    elements :errors, '.field_with_errors'
    element :error_summary, '.t-errors'

    section :activity_feed, Sections::ActivityFeed, '.t-activity-feed'

    def advance_date!
      chosen_date = date.value ? date.value.to_date : Date.current

      date.set(chosen_date.advance(days: 1))
    end

    def set_time(hour:, minute:)
      time_hour.select(hour)
      time_minute.select(minute)
    end

    def time
      "#{time_hour.value}:#{time_minute.value}"
    end
  end
end
