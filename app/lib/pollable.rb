module Pollable
  def self.included(base)
    base.helper_method :poll_interval_milliseconds
  end

  def poll_interval_milliseconds
    Integer(ENV.fetch(Activity::POLLING_KEY, 5000))
  end
end
