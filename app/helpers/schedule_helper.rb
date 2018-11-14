module ScheduleHelper
  def slots_by_month(slots)
    [].tap do |result|
      grouped = slots.group_by { |slot| slot.date.to_date.strftime('%B %Y') }
      grouped.map do |month_year, day_slots|
        result << [month_year, grouped_day(day_slots)]
      end
    end
  end

  def grouped_day(day_slots)
    day_slots.group_by(&:start_at).values.map(&:first).map do |slot|
      [
        "#{slot.date.to_date.strftime('%A, %d %b')} - #{slot_period(slot)}",
        "#{slot.date}-#{slot.start}-#{slot.end}"
      ]
    end
  end

  def slot_period(slot)
    return slot.start_at.to_s(:govuk_time) if slot.realtime?

    slot.period == 'am' ? 'Morning' : 'Afternoon'
  end

  def summary(period, schedule)
    open = schedule.public_send(period)
    day, slot = period.to_s.split('_')

    content_tag(:div, '', class: classes(day, slot, open), title: title(day, slot, open)) +
      content_tag(:span, title(day, slot, open), class: 'sr-only')
  end

  def classes(day, slot, open)
    "schedule-summary__period t-#{day}-#{slot}".tap do |classes|
      classes.concat(' schedule-summary__period--on') if open
    end
  end

  def title(day, slot, open)
    "#{open ? 'Open' : 'Closed'} #{day.humanize} #{slot.upcase}"
  end

  def availability_button(location_id)
    return unless Schedule.exists?(location_id: location_id)

    link_to(
      bookable_slots_path(location_id: location_id),
      title: 'Modify availability',
      class: 'btn btn-info t-availability'
    ) do
      content_tag(:span, '', class: 'glyphicon glyphicon-th', 'aria-hidden' => 'true') +
        content_tag(:span, 'Modify availability', class: 'sr-only')
    end
  end

  def realtime_availability_button(location)
    return unless location.realtime?
    return unless Schedule.exists?(location_id: location.id)

    link_to(
      realtime_bookable_slots_path(location_id: location.id),
      title: 'Modify realtime availability',
      class: 'btn btn-info t-realtime-availability'
    ) do
      content_tag(:span, '', class: 'glyphicon glyphicon-time', 'aria-hidden' => 'true') +
        content_tag(:span, 'Modify realtime availability', class: 'sr-only')
    end
  end
end
