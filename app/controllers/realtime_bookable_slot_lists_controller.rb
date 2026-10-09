class RealtimeBookableSlotListsController < ApplicationController
  include Guiderable

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
end
