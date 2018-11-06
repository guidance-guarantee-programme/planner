/* global moment, alertify */
{
  'use strict';

  class RealtimeCalendar {
    start(el) {
      this.$el = el;
      this.$slotsUri = this.$el.data('slots-uri')
      this.$guidersUri = this.$el.data('guiders-uri')
      this.$appointmentsUri = this.$el.data('appointments-uri')

      $(this.$el).fullCalendar({
        header: {
          right: 'prev,next'
        },
        resourceLabelText: 'Guider',
        nowIndicator: true,
        allDaySlot: false,
        groupByDateAndResource: true,
        buttonText: {
          today: 'Jump to today'
        },
        slotLabelInterval: { 'minutes': 15 },
        displayEventTime: false,
        columnFormat: 'ddd D/M',
        height: 'auto',
        maxTime: '18:45:00',
        minTime: '08:30:00',
        weekends: false,
        defaultView: 'agendaDay',
        slotDuration: '00:10:00',
        showNonCurrentDates: false,
        defaultDate: moment(el.data('default-date')),
        firstDay: 1,
        resources: this.$guidersUri,
        eventSources: [
          {
            url: this.$slotsUri,
            rendering: 'background',
            eventType: 'slot'
          },
          {
            url: this.$appointmentsUri,
            eventType: 'appointment'
          }
        ],
        dayClick: (date, jsEvent, _, resourceObject) => {
          jsEvent.preventDefault()

          if (jsEvent.target.classList.contains('js-slot')) {
            this.deleteSlot(jsEvent)
          } else {
            this.createSlot(date, resourceObject)
          }
        },
        eventRender: (event, element) => {
          if (event.source.ajaxSettings.eventType === 'slot') {
            $(element).addClass('t-slot js-slot')
          } else {
            $(element).addClass('t-appointment js-appointment')

            if(event.cancelled) {
              $(element).addClass('fc-event--cancelled')
            }
          }

          $(element).attr('id', event.id)
        },
        resourceRender: (resource, labelTds) => {
          labelTds.addClass('t-guider')
        },
        loading: (isLoading) => {
          if (isLoading) {
            // mark the calendar as reloading
            $('.t-calendar-rendered').remove()
          }

          this.insertLoadingView();

          if (!isLoading && this.$loadingSpinner) {
            clearTimeout(this.loadingTimeout);
            return this.$loadingSpinner.addClass('hide');
          }

          this.loadingTimeout = setTimeout(() => {
            if (isLoading && this.$loadingSpinner) {
              this.$loadingSpinner.removeClass('hide');
            }
          }, 200);
        },
        schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source'
      });
    }

    deleteSlot(jsEvent) {
      alertify
        .theme('bootstrap')
        .okBtn('OK')
        .confirm('Are you sure you want to delete this slot?', (e) => {
          e.preventDefault()

          const id = jsEvent.target.id

          $.ajax({
            type: 'DELETE',
            url: `${this.$slotsUri}/${id}`,
            headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
            success: () => {
              $(this.$el).fullCalendar('refetchEvents')
            },
            error: () => {
              alertify.theme('bootstrap').alert('You cannot delete this slot.')
            }
          })
        })
    }

    showSpinner() {
      this.$loadingSpinner.removeClass('hide');
    }

    hideSpinner() {
      this.$loadingSpinner.addClass('hide');
    }

    insertLoadingView() {
      if (this.$loadingSpinner) {
        return;
      }

      this.$loadingSpinner = $(`
         <div class="calendar-loading hide">
           <div class="loading-spinner loading-spinner--large">
             <div class="loading-spinner__bounce loading-spinner__bounce--1"></div>
             <div class="loading-spinner__bounce loading-spinner__bounce--2"></div>
             <div class="loading-spinner__bounce"></div>
           </div>
         </div>`);

      this.$loadingSpinner.appendTo($('.fc-view-container'));
    }

    createSlot(date, resourceObject) {
      $.post({
        url: this.$slotsUri,
        data: { start_at: date.utc().format(), guider_id: resourceObject.id },
        headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
        success: () => {
          $(this.$el).fullCalendar('refetchEvents')
        },
        error: () => {
          alertify.theme('bootstrap').alert('You cannot create a slot here.')
        }
      })
    }
  }

  window.GOVUKAdmin.Modules.RealtimeCalendar = RealtimeCalendar;
}
