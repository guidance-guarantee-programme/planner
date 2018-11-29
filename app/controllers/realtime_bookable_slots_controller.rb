class RealtimeBookableSlotsController < ApplicationController
  before_action :load_schedule

  def index
    @location = booking_location.location_for(params[:location_id])

    respond_to do |format|
      format.html
      format.json { render_realtime_bookable_slots_json }
    end
  end

  def create
    @schedule.create_realtime_bookable_slot!(
      start_at: Time.zone.parse(params[:start_at]),
      guider_id: params[:guider_id]
    )

    head :created
  end

  def destroy
    @schedule.bookable_slots.realtime.destroy(params[:id])

    head :no_content
  end

  private

  def load_schedule
    @schedule = Schedule.current(params[:location_id])
  end

  def render_realtime_bookable_slots_json
    render json: @schedule.bookable_slots_in_window(date_range).realtime.all,
           each_serializer: CalendarBookableSlotSerializer
  end

  def date_range
    {
      starting: params.fetch(:start) { Date.current.beginning_of_day }.to_date,
      ending: params.fetch(:end) { Date.current.end_of_day }.to_date
    }
  end
end
