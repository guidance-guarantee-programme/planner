class AdministratorsController < ApplicationController
  layout 'admin'
  helper_method :current_page?

  def index
  end

  def slots
    @current_page = 'slots'
  end

  private

  def current_page?(page)
    page == @current_page
  end
end
