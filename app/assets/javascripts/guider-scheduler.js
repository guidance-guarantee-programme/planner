$(function() {
  $('#guider-calendar').fullCalendar({
    schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
    aspectRatio: 2,
    editable: false,
    scrollTime: '07:00',
    header: {
      left: 'today prev,next',
      center: 'title',
      right: 'agendaDay, agendaWeek, month'
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
    // eventOverlap: false, // replace with a function to determine if the event was cancelled, in which case allow the overlap
    resources: (function() {
      var resources = [];
      resources.push(thisGuider());
      return resources;
    }()),
    events: (function() {
      return events();
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
function thisGuider() {
  var guider = guiders['Group1'][0];

  return {
    id: 'Ben Barnett',
    title: guider.name
  }
}

/**
 * Generate some random events for the guiders
 * @param  {[type]} bookingLocation [description]
 * @return {[type]}                 [description]
 */
function events() {
  var customers = ['Ann Robinson', 'Geoffrey Cooper', 'Amanda Hart', 'Betty Swooble', 'Nigel Mansel', 'Barry White'];
  var events = [];
  var guider = thisGuider();

  var numDays = 30;

  // Add the potential schedule for this group
  schedule['Group1'].forEach(function(potentialSlot, i) {

    for (var i = 0; i < numDays; i++) {
      var date = moment('2016-07-12').add(i, 'days');

      if (date.day() == 6 || date.day() == 0) {
        continue;
      }

      // Randomly add appointments to each of these slots to demo availability
      var randomSkipper = Math.random() * 3;
      if (randomSkipper < 2) {
        var randomCustomer = customers[Math.floor(Math.random()*customers.length)];
        events.push({
          id: 'event' + guider.id + i,
          resourceId: guider.id,
          start: date.format('YYYY-MM-DD') + 'T' + potentialSlot,
          title: randomCustomer,
          guider: guider.id
        });
      }
    }
  });

  return events;
}
