class GracePeriod
  def start
    date  = 5.working.days.from_now.to_date
    date += 1.working.day if exclusions.include?(date)
    date
  end

  def end
    40.working.days.from_now.to_date
  end

  private

  def exclusions
    Exclusions.new
  end
end
