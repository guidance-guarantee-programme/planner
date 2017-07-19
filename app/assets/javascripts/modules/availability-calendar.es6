/* global moment */
{
  'use strict';

  class AvailabilityCalendar {
    start(el) {
      this.$el = el;
      this.$modal = this.$el.find('.js-availability-modal');
      this.$editUri = this.$el.data('edit-slots-uri');

      $(this.$el).fullCalendar({
        header: {
          right: 'month today prev,next'
        },
        allDaySlot: false,
        buttonText: {
          agendaDay: 'Day',
          today: 'Jump to today',
          month: 'Month'
        },
        displayEventTime: false,
        columnFormat: 'ddd D/M',
        height: 'auto',
        weekends: false,
        defaultView: 'month',
        slotDuration: '12:00:00',
        slotLabelFormat: 'A',
        showNonCurrentDates: false,
        defaultDate: moment(el.data('default-date')),
        firstDay: 1,
        events: el.data('slots-uri'),
        eventRender: (event, element) => {
          $(element).attr('id', event.id);

          element.find('.fc-content').addClass('availability-calendar__event--on t-event');

          if (event.appointments) {
            $(element).prepend(`
              <span class="appointment-calendar__appointment-count">
                <span aria-hidden="true" class="glyphicon glyphicon-user"></span>
                <span class="t-appointment-count">${event.appointments}</span>
                <span class="sr-only"> appointments in this time period</span>
              </span>
            `);
          }
        },
        eventAfterRender: (event, element) => {
          element.closest('td').addClass(`t-slot-${event.id}`);
        },
        eventClick: (event) => {
          this.availabilityModal(event.start);
        },
        dayClick: (date) => {
          this.availabilityModal(date);
        },
        eventAfterAllRender: () => {
          // mark the calendar as reloaded
          let $rendered = $("<div class='t-calendar-rendered' style='display:hidden;'></div>")
          $('body').append($rendered);
        }
      });
    }

    availabilityModal(date) {
      var editUri = `${this.$editUri}?date=${date.format()}`;

      // mark the calendar for reloading
      $('.t-calendar-rendered').remove();

      this.$modal.modal().find('.modal-content').load(editUri);
    }
  }

  window.GOVUKAdmin.Modules.AvailabilityCalendar = AvailabilityCalendar;
}
