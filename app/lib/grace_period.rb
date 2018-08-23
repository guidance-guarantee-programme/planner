class GracePeriod
  GRACE_PERIODS = {
    3 => :monday,
    4 => :tuesday,
    5 => :wednesday,
    6 => :wednesday,
    0 => :wednesday
  }.freeze

  def initialize(from = Date.current)
    @from = from
  end

  def call
    if from.monday? || from.tuesday?
      from.advance(days: 3)
    else
      from.next_week(GRACE_PERIODS[from.wday])
    end
  end

  private

  attr_reader :from
end
