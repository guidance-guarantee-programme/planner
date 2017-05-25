class DefaultBookableSlots
  Instance = Struct.new(:date, :start, :end) do
    def label
      "#{date.to_date.strftime('%A').downcase}_#{period}"
    end

    def period
      start == '0900' ? 'am' : 'pm'
    end
  end

  attr_reader :from
  attr_reader :to

  def initialize(from: Date.current, to: from.advance(weeks: 6))
    @from = from
    @to   = to
  end

  def call
    available_days.map do |date|
      [
        Instance.new(date.iso8601, '0900', '1300'),
        Instance.new(date.iso8601, '1300', '1700')
      ]
    end.flatten
  end

  private

  def available_days
    (grace_period_end..to).reject { |day| day.on_weekend? || bank_holiday?(day) }
  end

  def bank_holiday?(date)
    BANK_HOLIDAYS.include?(date)
  end

  def grace_period_end
    if from.monday? || from.tuesday?
      from.advance(days: 3)
    else
      from.next_week(GRACE_PERIODS[from.wday])
    end
  end
end
