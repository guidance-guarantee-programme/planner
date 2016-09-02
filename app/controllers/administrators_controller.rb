class AdministratorsController < ApplicationController
  layout 'admin'
  helper_method :current_page?
  helper_method :periods
  helper_method :slots_by_group

  def index
  end

  def slots
    @current_page = 'slots'
  end

  def groups
    @current_page = 'groups'
  end

  def guiders
    @current_page = 'guiders'
  end

  private

  def current_page?(page)
    page == @current_page
  end

  # Periods of slot availabilty
  # Note: the last period cannot have an end date
  #       and the periods must be contiguous
  def periods
    [
      [Date.new(2016, 1, 1), Date.new(2016, 5, 31)],
      [Date.new(2016, 6, 1), Date.new(2016, 10, 31)],
      [Date.new(2016, 11, 1)]
    ]
  end

  # The group's availabilty per slot period
  def slots_by_group(period_index)
    [
      {
        'Group 1': ['08:30', '09:50', '11:20', '13:30', '14:50'],
        'Group 2': ['09:30', '10:50', '12:20', '14:30', '15:50'],
        'Group 3': ['11:20', '12:20', '13:50', '16:00', '17:20']
      },
      {
        'Group 1': ['08:30', '09:50', '11:20'],
        'Group 2': ['09:30', '10:50', '12:20', '14:30'],
        'Group 3': ['11:20', '12:20', '16:00', '17:20']
      },
      {
        'Group 1': ['13:30', '14:50'],
        'Group 2': ['09:30', '10:50'],
        'Group 3': ['11:20', '12:20', '13:50', '16:00', '17:20']
      },
    ][period_index]
  end
end
