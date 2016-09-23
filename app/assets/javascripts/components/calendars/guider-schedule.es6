module.exports = {
  fullCalendar: {
    views: {
      agendaDay: {
        buttonText: 'Day View'
      },
      agendaWeek: {
        buttonText: 'Week View'
      }
    },
    header: {
      left: 'today prev,next',
      center: 'title',
      right: 'agendaDay, agendaWeek'
    },
    eventRender: function(event, element) {
      function statusIconName(status) {
        var iconMapping = {
          'completed': 'ok',
          'pending': 'time',
          'ineligible_age': 'remove',
          'no_show': 'remove',
          'ineligible_pension_type': 'remove',
          'cancelled_by_customer': 'remove',
          'cancelled_by_pension_wise': 'remove'
        };

        return iconMapping[status];
      }

      element.html(`
        <p>${event.name} (${event.locationName})</p>
        <p>
          <span class="glyphicon glyphicon-user"></span> ${event.guiderName}
          <span class="glyphicon glyphicon-${statusIconName(event.status)}"></span>
        </p>
      `);
    },
    resourceRender: function(resourceObj, labelTds, bodyTds) {
      labelTds.addClass(resourceObj.eventClassName[0]);
    }
  }
};
