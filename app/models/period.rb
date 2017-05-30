Period = Struct.new(:start, :end) do
  def am?(time)
    time == start
  end

  def pm?(time)
    time == self.end
  end

  def period(start)
    am?(start) ? 'am' : 'pm'
  end

  def pair
    [start, self.end]
  end
end
