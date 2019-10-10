class LocationsController < ApplicationController
  def index
    @search = LocationSearch.new(search_params)
    @search.validate
  end

  private

  def search_params
    params
      .fetch(:search, {})
      .permit(:postcode)
      .merge(booking_location: booking_location)
  end
end
