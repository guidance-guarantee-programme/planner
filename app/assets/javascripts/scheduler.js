$(function() {
  $('#calendar').fullCalendar({
    schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
    aspectRatio: 3,
    height: '100%',
    editable: true,
    scrollTime: '07:00',
    header: {
      left: 'today prev,next',
      center: 'title'
    },
    slotDuration: '01:00',
    defaultTimedEventDuration: '01:00',
    forceEventDuration: true,
    businessHours: {
      start: '08:00',
      end: '19:00',
      dow: [1, 2, 3, 4, 5]
    },
    minTime: '08:00',
    maxTime: '19:00',
    snapDuration: '00:30',
    defaultView: 'agendaDay',
    now: '2016-07-12',
    allDaySlot: false,
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

var guiders = {
  'Group1': ['Ben Barnett', 'Ben Lovell', 'Matt Lucht', 'Tim Reichardt'],
  'Group2': ['Mary Jones', 'David Henry', 'Chris Winfrey', 'Henry Kissinger', 'Harry Doylie'],
  'Group3': ['Sally Murray', 'Beryl Clerk']
};

var constraints = {
  'Group1': {
    start: 9,
    end: 14
  },
  'Group2': {
    start: 12,
    end: 18
  },
  'Group3': {
    start: 15,
    end: 19
  }
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
    // Add the time constraints for this group
    events.push({
      id: 'constraint_' + group + guider.id,
      rendering: 'background',
      start: constraints[group].start + ':00:00',
      end: constraints[group].end + ':00:00',
      resourceId: guider.id
    });

    customers.forEach(function(name, i) {
      var randomSkipper = Math.random() * 2;
      if (randomSkipper >= 1) return false;

      startTime = randomTimeInConstraint(parseFloat(constraints[group].start), parseFloat(constraints[group].end));

      events.push({
        id: 'event' + group + guider.id + i,
        resourceId: guider.id,
        start: '2016-07-12T' + startTime,
        title: name,
        constraint: 'constraint_' + group + guider.id
      });
    });
  });

  return events;
}


function randomTimeInConstraint(start, end) {
  var hour = start + Math.random() * (end - start) | 0;
  return hour + ':00:00';
}
