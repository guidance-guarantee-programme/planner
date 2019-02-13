class Exclusions
  OTHER_HOLIDAYS = %w(25/12/2019 26/12/2019).map(&:to_date)
  BANK_HOLIDAYS  = %w(
    19/04/2019
    22/04/2019
    06/05/2019
    27/05/2019
    26/08/2019
  ).map(&:to_date)

  ALL_HOLIDAYS = OTHER_HOLIDAYS + BANK_HOLIDAYS

  def initialize(location_id)
    @location_id = location_id
  end

  delegate :include?, to: :holidays

  def holidays
    CAS_LOCATION_IDS.include?(location_id) ? OTHER_HOLIDAYS : ALL_HOLIDAYS
  end

  private

  attr_reader :location_id
end
