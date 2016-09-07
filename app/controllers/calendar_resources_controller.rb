class CalendarResourcesController < ApplicationController
  def index
    render json: calendar_resources
  end

  private

  def calendar_resources
    booking_location.guiders.map do |guider|
      CalendarResourcePresenter.new(guider)
    end
  end
end
