Period = Struct.new(:start, :end) do
  def am?(time = '0900')
    time == start
  end

  def pm?(time = '1700')
    time == self.end
  end

  def period(start)
    am?(start) ? 'am' : 'pm'
  end

  def pair
    [start, self.end]
  end
end
