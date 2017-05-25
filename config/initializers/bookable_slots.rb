# Days to advance when covering grace period
GRACE_PERIODS = {
  3 => :monday,
  4 => :tuesday,
  5 => :wednesday,
  6 => :thursday,
  0 => :thursday
}.freeze

# Days that are always excluded from availability
BANK_HOLIDAYS = [
  Date.parse('29/05/2017'),
  Date.parse('28/08/2017'),
  Date.parse('25/12/2017'),
  Date.parse('26/12/2017')
].freeze
