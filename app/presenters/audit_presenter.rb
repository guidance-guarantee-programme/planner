class AuditPresenter < SimpleDelegator
  def initialize(object, booking_location)
    super(object)

    @booking_location = booking_location
  end

  def changed_fields
    audited_changes.keys.map(&:humanize).to_sentence.downcase
  end

  def timestamp
    created_at.to_s(:govuk_date_short)
  end

  def username
    user ? user.name : 'Someone'
  end

  def changes
    audited_changes.each_with_object({}) do |(key, value), memo|
      field = key.humanize
      before, after = value.map(&:to_s)

      memo[field] = {
        before: format(key, before),
        after: format(key, after)
      }
    end
  end

  def self.wrap(objects, booking_location)
    Array(objects).map { |object| new(object, booking_location) }
  end

  private

  attr_reader :booking_location

  def format(key, value) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
    case key
    when 'secondary_status'
      Appointment::SECONDARY_STATUSES.values.reduce(&:merge)[value] || '-'
    when 'guider_id'
      booking_location.guider_name_for(value.to_i)
    when 'location_id'
      booking_location.name_for(value)
    when 'status'
      value.humanize
    when 'proceeded_at'
      Time.zone.parse(value).to_s(:govuk_date)
    else
      value
    end
  end
end
