class AppointmentConfirmationSerializer < ActiveModel::Serializer
  attribute :reference
  attribute :proceeded_at
  attribute :location

  def location
    object.location_name
  end
end
