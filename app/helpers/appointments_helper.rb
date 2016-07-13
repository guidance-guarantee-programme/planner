module AppointmentsHelper
  def appointments
    appointments = []

    10.times do
      appointments << random_appointment
    end

    appointments
  end

  private

  def random_appointment
    {
      :id => [1, 2, 3, 4, 5].sample,
      :datetime => time_rand(Time.local(2016, 7, 5), Time.local(2016, 7, 31)),
      :name => ["Barry Scott", "Michael Jones", "Mary Winfrey"].sample,
      :guider => ["Ben Barnett", "Ben Lovell", "Matt Lucht"].sample,
      :location => ["Hackney", "Dalston", "Walthamstow"].sample
    }
  end

  def time_rand(from = 0.0, to = Time.now)
    Time.at(from + rand * (to.to_f - from.to_f)).to_datetime
  end
end
