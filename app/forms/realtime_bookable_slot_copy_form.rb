class RealtimeBookableSlotCopyForm
  include ActiveModel::Model

  attr_accessor :guider_id
  attr_accessor :date
  attr_accessor :day_ids
  attr_accessor :slots
  attr_accessor :date_range
  attr_accessor :location_id
  attr_accessor :booking_location

  validates :slots, presence: true
  validates :day_ids, presence: true
  validates :date_range, presence: true

  def guider_name
    booking_location.guider_name_for(guider_id.to_i)
  end

  def time_slots
    schedule.bookable_slots.where(date: date, guider_id: guider_id)
  end

  def call # rubocop:disable AbcSize
    return if invalid?

    dates.select { |day| day_ids.include?(day.wday.to_s) }.each do |date|
      slots.map(&:to_time).each do |time|
        start_at = date.to_time.change(hour: time.hour, min: time.min) # rubocop:disable Rails/Date

        schedule.find_or_create_realtime_bookable_slot(
          start_at: start_at,
          guider_id: guider_id
        )
      end
    end
  end

  private

  def dates
    return Date.current..Date.current if date_range.blank?

    Range.new(*date_range.split(' - ').map(&:to_date))
  end

  def schedule
    @schedule ||= Schedule.current(location_id)
  end
end
