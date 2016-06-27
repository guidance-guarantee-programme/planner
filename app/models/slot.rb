class Slot < ActiveRecord::Base
  PERMITTED_TIME_REGEX = /\A\d{4}\z/
  PERMITTED_PRIORITIES = [1, 2, 3].freeze

  belongs_to :booking_request

  validates :date, presence: true
  validates :priority, inclusion: { in: PERMITTED_PRIORITIES }
  validates :from, format: { with: PERMITTED_TIME_REGEX }
  validates :to, format: { with: PERMITTED_TIME_REGEX }
  validate :validate_from_before_to

  def morning?
    from < '1300'
  end

  def to_s
    "#{date.to_s(:gov_uk)} - #{period}"
  end

  def period
    morning? ? 'morning' : 'afternoon'
  end

  private

  def validate_from_before_to
    errors.add(:base, 'from must be before to') unless from < to
  end
end
