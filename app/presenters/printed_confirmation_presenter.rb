class PrintedConfirmationPresenter
  delegate :reference, :booking_request, :updated?, to: :appointment

  def initialize(booking_location, appointment)
    @appointment = LocationAwareEntity.new(entity: appointment, booking_location: booking_location)
  end

  def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    {
      reference: reference,
      date: date,
      time: time,
      location: location,
      guider: appointment.guider_name.split.first,
      phone: appointment.online_booking_twilio_number,
      address_line_1: appointment.name,
      address_line_2: appointment.address_line_one,
      address_line_3: appointment.address_line_two,
      address_line_4: appointment.address_line_three,
      address_line_5: appointment.town,
      address_line_6: appointment.county,
      postcode: appointment.postcode,
      bsl: appointment.booking_request.bsl? ? 'Yes' : 'No'
    }
  end

  private

  def date
    appointment.proceeded_at.to_date.to_s(:govuk_date)
  end

  def time
    "#{appointment.proceeded_at.to_s(:govuk_time)} (#{appointment.timezone})"
  end

  def location
    [
      appointment.location_name,
      appointment.address_lines
    ].flatten.join("\n")
  end

  attr_reader :appointment
end
