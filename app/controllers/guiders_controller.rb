class GuidersController < ApplicationController
  def index
    render json: active_guiders, each_serializer: GuiderSerializer
  end

  private

  def active_guiders
    booking_location
      .guiders
      .reject { |guider| guider.name.start_with?('[INACTIVE]') }
  end
end
