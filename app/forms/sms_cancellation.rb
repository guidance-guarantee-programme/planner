class SmsCancellation
  include ActiveModel::Model

  attr_accessor :source_number, :message

  validates :source_number, presence: true
  validates :message, presence: true, format: { with: /\A'?cancel'?/i }

  def call
    if valid? && appointment
      appointment.cancel!
      send_notifications
    else
      SmsCancellationFailureJob.perform_later(source_number)
    end
  end

  private

  def send_notifications
    BookingManagerSmsCancellationJob.perform_later(appointment)
    SmsCancellationSuccessJob.perform_later(appointment)
  end

  def appointment
    @appointment ||= Appointment.for_sms_cancellation(normalised_source_number)
  end

  def normalised_source_number
    source_number.sub(/\A44/, '0').delete(' ')
  end
end
