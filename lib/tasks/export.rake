namespace :export do # rubocop:disable BlockLength
  QUERIES = {
    'MAPS_PWBLZ_PLANNERAPPOINT_' => 'id, booking_request_id, guider_id, proceeded_at, status, created_at, updated_at',
    'MAPS_PWBLZ_PLANNERBKSLT_'   => 'id, schedule_id, guider_id, start_at, end_at, created_at, updated_at',
    'MAPS_PWBLZ_PLANNERBKREQ_'   => 'id, agent_id, pension_provider, where_you_heard, gdpr_consent, booking_location_id,
                                     defined_contribution_pot_confirmed, age_range, created_at, updated_at',
    'MAPS_PWBLZ_PLANNERORGLKUP_' => 'id, organisation, location_id, created_at, updated_at',
    'MAPS_PWBLZ_PLANNERREPSUM_'  => 'id, location_id, four_week_availability, first_available_slot_on,
                                     created_at, updated_at'
  }.freeze

  desc 'Export CSV data to blob storage for analysis'
  task blob: :environment do
    export_to_azure_blob('MAPS_PWBLZ_PLANNERAPPOINT_', Appointment)
    export_to_azure_blob('MAPS_PWBLZ_PLANNERBKSLT_', BookableSlot)
    export_to_azure_blob('MAPS_PWBLZ_PLANNERBKREQ_', BookingRequest)
    export_to_azure_blob('MAPS_PWBLZ_PLANNERORGLKUP_', OrganisationLookup)
    export_to_azure_blob('MAPS_PWBLZ_PLANNERREPSUM_', ReportingSummary)
  end

  def export_to_azure_blob(key, model_class)
    model_class.public_send(:acts_as_copy_target)

    data = model_class.select(QUERIES[key]).order(:created_at).copy_to_string

    client = Azure::Storage::Blob::BlobService.create_from_connection_string(
      ENV.fetch('AZURE_CONNECTION_STRING')
    )

    client.create_block_blob(
      'pw-prd-data',
      "#{key}#{Time.current.strftime('%Y%m%d%H%M%S')}.csv",
      data
    )
  end
end
