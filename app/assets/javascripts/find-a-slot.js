$(function() {
  $('#calendar-slot-finder').fullCalendar({
    schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
    aspectRatio: 2,
    editable: false,
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
    selectOverlap: function(event) {
      if (event.rendering === 'background') {
        var guider = $('#calendar-slot-finder').fullCalendar('getResourceById', event.resourceId);
        var chosenTime = event.start.format();

        console.log('Chosen time with ' + guider.title + ' at ' + chosenTime);
        $('#calendar-slot-finder').fullCalendar('removeEvents', 'selectedEvent');
        $('#calendar-slot-finder').fullCalendar('renderEvent', {
          id: 'selectedEvent',
          resourceId: event.resourceId,
          title: $('#calendar-slot-finder').data('name'),
          start: chosenTime,
          color: '#c00',
          editable: true
        });

        $('#guider_id').val(guider.id);
        $('#datetime').val(chosenTime);
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
  var customers = ['Ann Robinson', 'Geoffrey Cooper', 'Amanda Hart', 'Betty Swooble', 'Nigel Mansel', 'Barry White'];
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
          guider: guider.id
        });
      }
    });

  });

  return events;
}
