module Qualtrics
  module Presenters
    class Appointment
      def initialize(appointment)
        @appointment = appointment
      end

      def to_h
        {
          reference: appointment.reference,
          first_name: appointment.first_name,
          last_name: appointment.last_name,
          email: appointment.email,
          mobile: appointment.phone,
          type:
        }
      end

      private

      attr_reader :appointment

      def type
        if appointment.bsl_video?
          'f2f-bsl-video'
        elsif appointment.video_appointment?
          'f2f-video'
        else
          'f2f-location'
        end
      end
    end
  end
end
