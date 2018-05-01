class SchedulesController < ApplicationController
  class InvalidPageError < ArgumentError; end
  class PageRangeError < ArgumentError; end

  rescue_from InvalidPageError, PageRangeError, with: :redirect_to_first_page

  def index
    @booking_location = booking_location
    @child_locations  = paginate_locations(booking_location)
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

  def paginate_locations(booking_location)
    locations = booking_location.visible_locations

    total_pages  = (locations.size.to_f / per_page).ceil
    current_page = page_param

    unless (1..total_pages).cover?(current_page)
      raise PageRangeError, 'Page number out of range'
    end

    offset = (current_page - 1) * per_page

    Kaminari.paginate_array(locations, limit: per_page, offset: offset)
  end

  def page_param
    Integer(params.fetch(:page, '1'))
  rescue ArgumentError
    raise InvalidPageError, 'Page number is invalid'
  end

  def redirect_to_first_page
    redirect_to schedules_path
  end

  def per_page
    Kaminari.config.default_per_page
  end
end
