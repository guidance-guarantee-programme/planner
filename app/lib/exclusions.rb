class Exclusions
  CAS_HOLIDAYS   = [].freeze
  PWNI_HOLIDAYS  = %w(2022-08-29).map(&:to_date).freeze
  CITA_HOLIDAYS  = %w(2022-08-29).map(&:to_date).freeze

  def initialize(location_id)
    @location_id = location_id
  end

  delegate :include?, to: :holidays

  def holidays
    return CAS_HOLIDAYS  if OrganisationLookup.cas_location_ids.include?(location_id)
    return PWNI_HOLIDAYS if OrganisationLookup.pwni_location_ids.include?(location_id)

    CITA_HOLIDAYS
  end

  private

  attr_reader :location_id
end
