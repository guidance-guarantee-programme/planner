class AppointmentSearchSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :reference
  attribute :name

  attribute :url do
    edit_appointment_url(object)
  end

  attribute :application do
    GovukAdminTemplate::Config.app_title
  end
end
