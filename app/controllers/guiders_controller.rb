class GuidersController < ApplicationController
  include Guiderable

  def index
    render json: guiders, each_serializer: GuiderSerializer
  end
end
