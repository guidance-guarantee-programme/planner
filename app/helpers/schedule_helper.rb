module ScheduleHelper
  def copy_modal_configuration
    date = 1.day.from_now.strftime('%d/%m/%Y')

    { ranges: false, minDate: date, startDate: date }.as_json
  end

  def weekday_options
    [[1, 'Monday'], [2, 'Tuesday'], [3, 'Wednesday'], [4, 'Thursday'], [5, 'Friday']]
  end

  def slots_by_month(slots)
    [].tap do |result|
      grouped = slots.group_by { |slot| slot.start_at.strftime('%B %Y') }
      grouped.map do |month_year, day_slots|
        result << [month_year, grouped_day(day_slots)]
      end
    end
  end

  def grouped_day(day_slots)
    day_slots.group_by(&:start_at).values.map(&:first).map do |slot|
      [
        "#{slot.start_at.strftime('%A, %d %b')} - #{slot_period(slot)}",
        "#{slot.start_at.to_date}-#{slot.start_at.strftime('%H%M')}-#{slot.end_at.strftime('%H%M')}"
      ]
    end
  end

  def slot_period(slot)
    return slot.start_at.to_s(:govuk_time) if slot.realtime?

    slot.period == 'am' ? 'Morning' : 'Afternoon'
  end

  def title(day, slot, open)
    "#{open ? 'Open' : 'Closed'} #{day.humanize} #{slot.upcase}"
  end

  def realtime_availability_button(location)
    return unless location.realtime?

    safe_join([bookable_slots_button(location), bookable_slot_list_button(location)], "\n")
  end

  def bookable_slots_button(location)
    link_to(
      realtime_bookable_slots_path(location_id: location.id),
      title: 'Modify realtime availability',
      class: 'btn btn-info t-realtime-availability'
    ) do
      content_tag(:span, '', class: 'glyphicon glyphicon-time', 'aria-hidden' => 'true') +
        content_tag(:span, 'Modify realtime availability', class: 'sr-only')
    end
  end

  def bookable_slot_list_button(location)
    link_to(
      realtime_bookable_slot_lists_path(location_id: location.id),
      title: 'View realtime slots',
      class: 'btn btn-info t-realtime-slots'
    ) do
      content_tag(:span, '', class: 'glyphicon glyphicon-info-sign', 'aria-hidden' => 'true') +
        content_tag(:span, 'View realtime slots', class: 'sr-only')
    end
  end
end
