class Exclusions
  CAS_HOLIDAYS   = %w(25/12/2019 26/12/2019 01/01/2020 02/01/2020).map(&:to_date)
  BANK_HOLIDAYS  = %w(25/12/2019 26/12/2019 01/01/2020).map(&:to_date)

  def initialize(location_id)
    @location_id = location_id
  end

  delegate :include?, to: :holidays

  def holidays
    CAS_LOCATION_IDS.include?(location_id) ? CAS_HOLIDAYS : BANK_HOLIDAYS
  end

  private

  attr_reader :location_id
end
