module Agent
  class BookingRequestsController < Agent::ApplicationController
    def index
      @search = AgentSearchForm.new(search_params)
      @booking_requests = @search.results.page(params[:page])
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
        send_notifications(@booking)

        redirect_to agent_booking_request_path(@booking, location_id: location_id)
      else
        render :new
      end
    end

    def show
      @booking = current_user.agent_bookings.find(params[:id])
    end

    private

    def postcode_api_key
      ENV.fetch('POSTCODE_API_KEY') { 'iddqd' } # default to test API key
    end
    helper_method :postcode_api_key

    def send_notifications(booking)
      CustomerConfirmationJob.perform_later(booking)
      BookingManagerConfirmationJob.perform_later(booking)
      SlackPingerJob.perform_later(booking)
    end

    def slots
      @slots ||= Schedule.current(location_id).bookable_slots_in_window
    end
    helper_method :slots

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
