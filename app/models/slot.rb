class Slot < ActiveRecord::Base
  NON_REALTIME_DURATION = 400
  PERMITTED_TIME_REGEX = /\A\d{4}\z/
  SLOT_REGEX = /\A(\d{4}-\d{2}-\d{2})-(\d{4})-(\d{4})\z/
  PERMITTED_PRIORITIES = [1, 2, 3].freeze

  belongs_to :booking_request, optional: true

  validates :date, presence: true
  validates :priority, inclusion: { in: PERMITTED_PRIORITIES }
  validates :from, format: { with: PERMITTED_TIME_REGEX }
  validates :to, format: { with: PERMITTED_TIME_REGEX }
  validate :validate_from_before_to

  def self.from(priority:, slot:)
    date, from, to = if SLOT_REGEX === slot # rubocop:disable CaseEquality
                       slot.match(SLOT_REGEX).captures
                     else
                       starting = Time.zone.parse(slot)
                       ending   = starting.advance(hours: 1)

                       [starting.to_date, starting.strftime('%H%M'), ending.strftime('%H%M')]
                     end

    new(priority: priority, date: date, from: from, to: to)
  end

  def self.parse_slot_text(priority:, slot:)
    date, from, to = slot.match(SLOT_REGEX).captures

    {
      priority: priority,
      date: date,
      from: from,
      to: to
    }
  end

  def realtime?
    to.to_i - from.to_i != NON_REALTIME_DURATION
  end

  def morning?
    from == '0900'
  end

  def to_s
    "#{formatted_date} - #{period}"
  end

  def start_at
    Time.zone.parse("#{date} #{from.dup.insert(2, ':')}")
  end

  def end_at
    Time.zone.parse("#{date} #{to.dup.insert(2, ':')}")
  end

  def formatted_date
    date.to_s(:gov_uk)
  end

  def period
    return delimited_from if realtime?

    morning? ? 'Morning' : 'Afternoon'
  end

  def delimited_from
    @delimited_from ||= from.insert(2, ':')
  end

  def mid_point
    mid_point_time = morning? ? '11:00' : '15:00'

    Time.zone.parse("#{date} #{mid_point_time}")
  end

  private

  def validate_from_before_to
    errors.add(:base, 'from must be before to') unless from < to
  end
end
