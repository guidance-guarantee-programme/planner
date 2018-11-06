class AppointmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :id
  attribute :name, key: :title

  attribute :resourceId do
    object.guider_id
  end

  attribute :start do
    object.proceeded_at
  end

  attribute :end do
    object.proceeded_at.advance(hours: 1)
  end

  attribute :cancelled do
    object.cancelled?
  end

  attribute :url do
    edit_appointment_path(object)
  end
end
