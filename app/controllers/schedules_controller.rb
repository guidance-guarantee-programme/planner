class SchedulesController < ApplicationController
  def index
    @booking_location = booking_location
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
        *Schedule.slot_attributes,
        :location_id
      )
  end
end
