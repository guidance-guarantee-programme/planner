class GracePeriod
  def initialize(location_id)
    @location_id = location_id
  end

  def start
    date  = 4.working.days.from_now.to_date
    date += 1.working.day if exclusions.include?(date)

    date
  end

  def end
    40.working.days.from_now.to_date
  end

  private

  attr_reader :location_id

  def exclusions
    Exclusions.new(location_id)
  end
end
