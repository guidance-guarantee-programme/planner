class Exclusions
  HOLIDAYS = %w(
    2026-04-03
    2026-04-06
    2026-05-04
    2026-05-25
    2026-08-31
  ).map(&:to_date)

  delegate :include?, to: :HOLIDAYS
end
