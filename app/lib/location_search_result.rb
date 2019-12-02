class LocationSearchResult < SimpleDelegator
  def initialize(location, distance)
    @distance = distance
    super(location)
  end

  def distance
    format('%.2f', @distance)
  end

  def numerical_distance
    @distance
  end

  def availability
    if Schedule.current(id).available?
      'Available'
    else
      'None'
    end
  end
end
