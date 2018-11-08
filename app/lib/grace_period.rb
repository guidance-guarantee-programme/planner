class GracePeriod
  def self.start
    3.working.days.from_now.to_date
  end

  def self.end
    40.working.days.from_now.to_date
  end
end
