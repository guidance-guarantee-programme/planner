class BookableSlotSerializer < ActiveModel::Serializer
  attribute :date
  attribute :start
  attribute :end
end
