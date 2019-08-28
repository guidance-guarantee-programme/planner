class CalendarBookableSlotSerializer < ActiveModel::Serializer
  attribute :id
  attribute :guider_id, key: :resourceId

  attribute :start do
    object.start_at
  end

  attribute :end do
    object.end_at
  end
end
