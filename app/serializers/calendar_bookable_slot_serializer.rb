class CalendarBookableSlotSerializer < ActiveModel::Serializer
  attribute :id
  attribute :guider_id, key: :resourceId

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
    object.guider_id ? 0 : object.appointments.count
  end

  def delimit(time)
    time.dup.insert(2, ':')
  end
end
