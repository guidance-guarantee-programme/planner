class Slot < ActiveRecord::Base
  PERMITTED_TIME_REGEX = /\A\d{4}\z/
  PERMITTED_PRIORITIES = [1, 2, 3].freeze

  belongs_to :booking_request, optional: true

  validates :date, presence: true
  validates :priority, inclusion: { in: PERMITTED_PRIORITIES }
  validates :from, format: { with: PERMITTED_TIME_REGEX }
  validates :to, format: { with: PERMITTED_TIME_REGEX }
  validate :validate_from_before_to

  def self.from(priority:, start_at:)
    start_at = start_at.in_time_zone

    new(
      priority: priority,
      date: start_at.to_date,
      from: start_at.strftime('%H%M')
    ).tap do |slot|
      slot.to = slot.morning? ? BookableSlot::AM.end : BookableSlot::PM.end
    end
  end

  def morning?
    BookableSlot::AM.am?(from)
  end

  def to_s
    "#{formatted_date} - #{period}"
  end

  def formatted_date
    date.to_s(:gov_uk)
  end

  def period
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
