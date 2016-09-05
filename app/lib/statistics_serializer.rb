class StatisticsSerializer
  def json
    statistics.to_json(
      only: [
        :booking_location_id,
        :average_fulfilment_time_seconds,
        :average_window_time_seconds
      ]
    )
  end

  private

  def statistics
    Appointment
      .joins(:booking_request)
      .select(
        :booking_location_id,
        'avg(appointments.fulfilment_time_seconds) as average_fulfilment_time_seconds',
        'avg(appointments.fulfilment_window_seconds) as average_window_time_seconds'
      )
      .group('booking_requests.booking_location_id')
  end
end
