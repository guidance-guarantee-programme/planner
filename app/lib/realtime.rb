module Realtime
  module_function

  mattr_accessor :pilot_locations

  def pilot?(id)
    pilot_locations.include?(id)
  end
end
