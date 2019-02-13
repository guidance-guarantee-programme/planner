class BookableSlotsController < ApplicationController
  def index
    @window   = GracePeriod.new(params[:location_id])
    @schedule = Schedule.current(params[:location_id])
    @location = booking_location.location_for(params[:location_id])

    respond_to do |format|
      format.html
      format.json { render_bookable_slots_json }
    end
  end

  def edit
    @form = AvailabilityForm.new(availability_params)

    render :edit, layout: false
  end

  def update
    AvailabilityForm.new(availability_params).upsert!
  rescue ActiveRecord::RecordInvalid
    @failed = true
  end

  private

  def render_bookable_slots_json
    render json: @schedule.bookable_slots_in_window(date_range).non_realtime.all,
           each_serializer: CalendarBookableSlotSerializer
  end

  def date_range
    {
      starting: params.fetch(:start) { Date.current.beginning_of_month }.to_date,
      ending: params.fetch(:end) { Date.current.end_of_month }.to_date
    }
  end

  def availability_params
    params.permit(:date, :schedule_id, :am, :pm)
  end
end
