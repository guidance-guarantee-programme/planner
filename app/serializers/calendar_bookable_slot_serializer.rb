class CalendarBookableSlotSerializer < ActiveModel::Serializer
  attribute :id

  attribute :start do
    Time.zone.parse("#{object.date} #{delimit(object.start)}")
  end

  attribute :end do
    Time.zone.parse("#{object.date} #{delimit(object.end)}")
  end

  attribute :title do
    BookableSlot::AM.period(object.start).upcase
  end

  attribute :appointments do
    object.appointments.count
  end

  def delimit(time)
    time.dup.insert(2, ':')
  end
end
