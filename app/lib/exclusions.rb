class Exclusions
  HOLIDAYS = %w(2022-12-26 2022-12-27 2023-01-02).map(&:to_date)

  delegate :include?, to: :HOLIDAYS
end
