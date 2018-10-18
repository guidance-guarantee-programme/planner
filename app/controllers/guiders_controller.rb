class GuidersController < ApplicationController
  def index
    render json: active_guiders, each_serializer: GuiderSerializer
  end

  private

  def active_guiders
    booking_location
      .location_for(params[:location_id])
      .guiders
      .reject { |guider| guider.name.start_with?('[INACTIVE]') }
  end
end
