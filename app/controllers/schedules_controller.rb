class SchedulesController < ApplicationController
  def index
    @booking_location = booking_location
    @child_locations  = booking_location.locations.reject(&:hidden?)
  end

  def new
    @location = booking_location.location_for(params[:location_id])
    @schedule = Schedule.new(location_id: params[:location_id])
  end

  def create
    @schedule = Schedule.create!(schedule_params)
    SlotGenerationJob.perform_later(@schedule)

    redirect_to schedules_path, notice: 'Schedule was created'
  end

  private

  def schedule_params
    params
      .require(:schedule)
      .permit(
        *Schedule::SLOT_ATTRIBUTES,
        :location_id
      )
  end
end
