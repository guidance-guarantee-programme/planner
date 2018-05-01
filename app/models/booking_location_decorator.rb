class BookingLocationDecorator < SimpleDelegator
  def name
    if hidden?
      "[HIDDEN] #{super}"
    else
      super
    end
  end

  def locations
    super.map { |l| BookingLocationDecorator.new(l) }
  end

  def visible_locations
    locations.reject(&:hidden?).sort_by(&:name)
  end

  def schedule
    @schedule ||= Schedule.current(id)
  end

  alias object __getobj__
end
