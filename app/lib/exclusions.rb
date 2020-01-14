class Exclusions
  CAS_HOLIDAYS   = %w(10/04/2020 25/12/2020 28/12/2020).map(&:to_date).freeze
  PWNI_HOLIDAYS  = %w(17/03/2020 10/04/2020 13/04/2020 08/05/2020 25/05/2020 31/08/2020 25/12/2020 28/12/2020).map(&:to_date).freeze # rubocop:disable LineLength
  CITA_HOLIDAYS  = %w(10/04/2020 13/04/2020 08/05/2020 25/05/2020 31/08/2020 25/12/2020 28/12/2020).map(&:to_date).freeze # rubocop:disable LineLength

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
