$(function() {
  $('#calendar').fullCalendar({
    schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
    aspectRatio: 2,
    editable: true,
    scrollTime: '07:00',
    header: {
      left: 'today prev,next',
      center: 'title',
      right: 'agendaDay, timelineDay'
    },
    views: {
      agendaDay: {
        buttonText: 'Vertical',
      },
      timelineDay: {
        buttonText: 'Horizontal'
      }
    },
    resourceLabelText: 'Guiders',
    resourceGroupField: 'group',
    slotDuration: '00:10',
    defaultTimedEventDuration: '01:00',
    forceEventDuration: true,
    businessHours: {
      start: '08:00',
      end: '19:00',
      dow: [1, 2, 3, 4, 5]
    },
    minTime: '08:00',
    maxTime: '19:00',
    snapDuration: '00:10',
    defaultView: 'agendaDay',
    now: '2016-07-12',
    allDaySlot: false,
    selectable: true,
    select: function(start, end, event, calendar, resource) {
      var title = prompt('Reason for blocking out time:');
      var eventData;

      if (title) {
        eventData = {
          id: 'blocker' + Math.random() * 10000,
          title: 'Blocked: ' + title,
          start: start,
          end: end,
          backgroundColor: '#c00',
          borderColor: '#c00',
          textColor: '#fff',
          resourceId: resource.id,
          blocked: true
        };
        $('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true
      }
      $('#calendar').fullCalendar('unselect');
    },
    eventDrop: function(event, delta, revertFunc, jsEvent, ui, view) {
      if (!event.blocked) {
        $('.js-event-updated-alert').html(event.title + "'s appointment updated").show().stop().delay(2000).fadeOut('slow');
      }
    },
    eventClick: function(event, jsEvent, view) {
      if (event.blocked === true) {
        if (confirm('Would you like to delete this time block?')) {
          $('#calendar').fullCalendar('removeEvents', [event.id]);
        }
      }
    },
    // eventOverlap: false, // replace with a function to determine if the event was cancelled, in which case allow the overlap
    resources: (function() {
      var resources = [];
      for (var group in guiders) {
        resources.push(guidersFor(group));
      }

      // flatten it
      return resources.reduce(function(a, b) {
        return a.concat(b);
      });
    }()),
    events: (function() {
      var events = [];
      for (var group in guiders) {
        events.push(eventsFor(group));
      }
      // flatten it
      return events.reduce(function(a, b) {
        return a.concat(b);
      });
    }())
  });
});

/**
 * An array of possible appointment start times for each group
 * A guider is always assigned to a group
 * @type {Object}
 */
var schedule = {
  'Group1': ['08:30', '09:50', '11:20', '13:30', '14:50'],
  'Group2': ['09:30', '10:50', '12:20', '14:30', '15:50'],
  'Group3': ['11:20', '12:20', '13:50', '16:00', '17:20']
}

/**
 * Return an array of guiders (Resources) for a given booking location
 * @param  {[type]} booking_location [description]
 * @return {[type]}                  [description]
 */
function guidersFor(group) {
  return guiders[group].map(function(name, i) {
    return {
      id: group + i,
      title: name,
      group: group
    }
  });
}

/**
 * Generate some random events for the guiders
 * @param  {[type]} bookingLocation [description]
 * @return {[type]}                 [description]
 */
function eventsFor(group) {
  var customers = ['Ben Barnett', 'Geoffrey Cooper', 'Amanda Hart', 'Mary Jackson', 'Nigel Mansel', 'Matt Lucht'];
  var events = [];

  guidersFor(group).forEach(function(guider) {
    // Add the potential schedule for this group
    schedule[group].forEach(function(potentialSlot, i) {
      events.push({
        id: 'potential_' + group + guider.id + i,
        rendering: 'background',
        start: potentialSlot,
        resourceId: guider.id
      });

      // Randomly add appointments to each of these slots to demo availability
      var randomSkipper = Math.random() * 3;
      if (randomSkipper < 2) {
        var randomCustomer = customers[Math.floor(Math.random()*customers.length)];

        events.push({
          id: 'event' + group + guider.id + i,
          resourceId: guider.id,
          start: '2016-07-12T' + potentialSlot,
          title: randomCustomer,
          group: group,
          guider: guider.id,
          url: '/appointments/1/edit'
        });
      }
    });

  });

  return events;
}
