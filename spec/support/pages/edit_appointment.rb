module Pages
  class EditAppointment < SitePrism::Page
    set_url '/appointments/{id}/edit'

    element :name, '.t-name'
    element :email, '.t-email'
    element :phone, '.t-phone'
    element :location, '.t-location'
    element :guider, '.t-guider'

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

    element :status, '.t-status'
    element :submit_status, '.t-submit-status'

    elements :errors, '.field_with_errors'
    element :error_summary, '.t-errors'
  end
end