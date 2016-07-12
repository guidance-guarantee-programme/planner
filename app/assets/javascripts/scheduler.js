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
    eventOverlap: false, // replace with a function to determine if the event was cancelled, in which case allow the overlap
    resourceRender: function(resourceObj, labelTds, bodyTds) {
      console.log(resourceObj);
    },
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
  'Group2': ['Mary Jones', 'David Henry', 'Chris Winfrey', 'Henry Kissinger', 'Harry Doylie']
};

var constraints = {
  'Group1': {
    id: 'constraint_Group1',
    start: '2016-07-12T10:00:00',
    end: '2016-07-12T16:00:00',
    rendering: 'background'
  },
  'Group2': {
    id: 'constraint_Group2',
    start: '2016-07-12T11:00:00',
    end: '2016-07-12T17:00:00',
    rendering: 'background'
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

  // Add the time constraints for this group
  // events.push(constraints[group]);

  guidersFor(group).forEach(function(guider) {
    customers.forEach(function(name, i) {
      events.push({
        id: 'event' + group + guider.id + i,
        resourceId: guider.id,
        start: '2016-07-12T' + (Math.floor(Math.random() * 13) + 6) + ':00:00',
        title: name,
        constraint: 'constraint_' + group
      });
    });
  });

  return events;
}
