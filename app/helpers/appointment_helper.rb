module AppointmentHelper
  def friendly_options(statuses)
    statuses.map { |k, _| [k.titleize, k] }.to_h
  end
end
