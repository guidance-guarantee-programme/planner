module ScheduleHelper
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
end
