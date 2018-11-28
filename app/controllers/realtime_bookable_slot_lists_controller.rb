class RealtimeBookableSlotListsController < ApplicationController
  def index
    @search = BookableSlotSearch.new(search_params)
    @slots  = @search.results
  end

  private

  def search_params
    params
      .fetch(:search, {})
      .permit(:date, :guider, :per_page)
      .merge(
        page: params[:page],
        location: location
      )
  end

  def location
    @location ||= booking_location.location_for(params[:location_id])
  end
  helper_method :location

  def guiders
    booking_location
      .guiders
      .reject { |guider| guider.name.start_with?('[INACTIVE]') }
  end
  helper_method :guiders
end
