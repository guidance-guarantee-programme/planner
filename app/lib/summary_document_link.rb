# rubocop:disable Naming/VariableNumber
class SummaryDocumentLink
  class << self
    attr_accessor :url

    def generate(appointment)
      "#{url}/appointment_summaries/new?#{query(appointment)}"
    end

    def query(appointment) # rubocop:disable Metrics/MethodLength
      date_of_appointment = appointment.proceeded_at.to_date
      {
        first_name: appointment.first_name,
        last_name: appointment.last_name,
        date_of_appointment: date_of_appointment.to_s,
        reference_number: appointment.reference,
        number_of_previous_appointments: 0,
        email: appointment.email,
        address_line_1: appointment.address_line_one,
        address_line_2: appointment.address_line_two,
        address_line_3: appointment.address_line_three,
        town: appointment.town,
        county: appointment.county,
        postcode: appointment.postcode,
        country: 'United Kingdom',
        telephone_appointment: false,
        welsh: appointment.welsh?,
        guider_name: guider_first_name(appointment)
      }.to_query(:appointment_summary)
    end

    private

    def guider_first_name(appointment)
      booking_location = BookingLocations.find(appointment.location_id)
      location = booking_location.location_for(appointment.location_id)

      guider_location = location.guiders.empty? ? booking_location : location
      guider_location.guider_name_for(appointment.guider_id).split(' ').first
    end
  end
end
# rubocop:enable Naming/VariableNumber
