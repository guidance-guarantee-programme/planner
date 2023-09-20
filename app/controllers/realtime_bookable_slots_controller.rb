class RealtimeBookableSlotsController < ApplicationController
  before_action :load_schedule
  before_action :load_window

  def index
    @location = booking_location.location_for(params[:location_id])

    respond_to do |format|
      format.html
      format.json { render_realtime_bookable_slots_json }
    end
  end

  def create
    @bookable_slot = @schedule.create_realtime_bookable_slot(
      start_at: Time.zone.parse(params[:start_at]),
      guider_id: params[:guider_id]
    )

    respond_to do |format|
      format.js do
        return head :ok if @bookable_slot.persisted?

        render :errors, layout: false, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @schedule.bookable_slots.realtime.destroy(params[:id])

    respond_to do |format|
      format.js { head :no_content }
      format.html do
        redirect_back fallback_location: realtime_bookable_slot_lists_path(location_id: @schedule.location_id),
                      success: 'The slot was deleted'
      end
    end
  end

  def future
    @schedule
      .bookable_slots
      .realtime
      .where('start_at >= ?', Time.current.beginning_of_day)
      .destroy_all

    redirect_back fallback_location: schedules_path, success: 'The schedule was successfully cleared'
  end

  private

  def load_window
    @window = GracePeriod.new(params[:location_id])
  end

  def load_schedule
    @schedule = Schedule.current(params[:location_id])
  end

  def render_realtime_bookable_slots_json
    render json: @schedule.bookable_slots_in_window(**date_range).realtime.all,
           each_serializer: CalendarBookableSlotSerializer
  end

  def date_range
    {
      starting: params.fetch(:start) { Date.current.beginning_of_day }.to_date,
      ending: params.fetch(:end) { Date.current.end_of_day }.to_date
    }
  end
end
