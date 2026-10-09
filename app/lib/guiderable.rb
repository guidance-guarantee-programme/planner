module Guiderable
  def guiders
    @guiders = booking_location.location_for(params[:location_id]).guiders
    @guiders = booking_location.guiders if @guiders.empty?
    @guiders.reject { |guider| guider.name.start_with?('[INACTIVE]') }
  end

  def self.included(base)
    base.helper_method :guiders
  end
end
