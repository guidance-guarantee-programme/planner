module Agent
  class BookingRequestsController < Agent::ApplicationController
    include RealtimeProcessable

    def index
      @search = AgentSearchForm.new(search_params)
      @booking_requests = @search.results
    end

    def new
      @booking = AgentBookingForm.new(booking_params)
    end

    def preview
      @booking = AgentBookingForm.new(booking_params)

      if @booking.valid?
        render :preview
      else
        render :new
      end
    end

    def create
      @booking = AgentBookingForm.new(booking_params)

      if creating?
        @booking = @booking.create_booking!
        process_booking_request(@booking)

        redirect_to agent_booking_request_path(@booking, location_id: location_id)
      else
        render :new
      end
    end

    def show
      @booking = current_user.agent_bookings.find(params[:id])
    end

    private

    def send_notifications(booking)
      CustomerConfirmationJob.perform_later(booking)
      BookingManagerConfirmationJob.perform_later(booking)
      SlackPingerJob.perform_later(booking)
    end

    def schedule
      @schedule ||= Schedule.current(location_id)
    end

    def slots
      @slots ||= schedule.without_appointments
    end
    helper_method :slots

    def realtime?
      schedule.realtime?
    end
    helper_method :realtime?

    def booking_params
      params
        .fetch(:booking, {})
        .permit(AgentBookingForm::ATTRIBUTES)
        .merge(
          booking_location_id: booking_location_id,
          location_id: location_id,
          agent: current_user
        )
    end

    def creating?
      params[:editing].nil?
    end

    def search_params # rubocop:disable MethodLength
      params
        .fetch(:search, {})
        .permit(
          :reference,
          :name,
          :status,
          :date,
          :agent
        ).merge(
          page: params[:page]
        )
    end
  end
end
