module TimeHelpers
  def time_today(time)
    Time.zone.parse("#{Date.current} #{time}")
  end
end
