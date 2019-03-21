/* global moment, alertify */
{
  'use strict';

  class RealtimeCalendar {
    start(el) {
      this.$el = el;
      this.$slotsUri = this.$el.data('slots-uri')
      this.$guidersUri = this.$el.data('guiders-uri')
      this.$appointmentsUri = this.$el.data('appointments-uri')
      this.$copySlotsUri = this.$el.data('copy-slots-uri')
      this.$modal = this.$el.find('.js-copy-modal')
      this.isFullscreen = false

      alertify.defaults.transition = 'fade'
      alertify.defaults.theme.ok = 'btn btn-primary t-ok'
      alertify.defaults.theme.cancel = 'btn btn-default'

      $(this.$el).fullCalendar({
        header: {
          right: 'fullscreen today jumpToDate jumpBackWeek,jumpForwardWeek prev,next'
        },
        titleFormat: 'dddd, Do MMMM',
        resourceLabelText: 'Guider',
        nowIndicator: true,
        allDaySlot: false,
        groupByDateAndResource: true,
        customButtons: {
          fullscreen: {
            text: 'Fullscreen',
            click: this.fullscreenClick.bind(this)
          },
          jumpToDate: {
            text: 'Jump to date',
            click: this.jumpToDateClick.bind(this)
          },
          jumpBackWeek: {
            text: '-7 days',
            click: this.jumpWeek.bind(this, false)
          },
          jumpForwardWeek: {
            text: '+7 days',
            click: this.jumpWeek.bind(this, true)
          }
        },
        buttonText: {
          today: 'Jump to today'
        },
        slotLabelInterval: { 'minutes': 15 },
        displayEventTime: false,
        columnFormat: 'ddd D/M',
        height: 'parent',
        maxTime: '18:45:00',
        minTime: '08:30:00',
        weekends: false,
        defaultView: 'agendaDay',
        slotDuration: '00:05:00',
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
        resourceRender: (resourceObj, labelTds, bodyTds, view) => {
          if (view.type === 'agendaDay') {
            labelTds.html('');

            var uri = `${this.$copySlotsUri}?guider_id=${resourceObj.id}&date=${this.getCurrentDate()}`;

            $(`<div class="t-guider">${resourceObj.title}</div>`).prependTo(labelTds);
            labelTds.on('click', this.showCopyModal.bind(this, uri)).addClass('resource-link');
          }
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

      this.insertJumpToDate();
      this.setCalendarToCorrectHeight();
    }

    showCopyModal(uri) {
      this.$modal.modal().find('.modal-content').load(uri);
    }

    deleteSlot(jsEvent) {
      alertify
        .confirm('<strong class="text-danger">Are you sure you want to delete this slot?</strong>',
                 'Clicking OK will delete the slot.', () => {
          const id = jsEvent.target.id

          $.ajax({
            type: 'DELETE',
            url: `${this.$slotsUri}/${id}`,
            headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
            success: () => {
              $(this.$el).fullCalendar('refetchEvents')
            },
            error: () => {
              alertify.alert('<strong class="text-danger">You cannot delete this slot</strong>', 'It has an associated appointment')
            }
          })
        },
          () => { /* this handler has to be here otherwise alertify does not cancel */ }
        )
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
        dataType: 'script',
        success: () => {
          $(this.$el).fullCalendar('refetchEvents')
        }
      })
    }

    jumpWeek(forward) {
      var current = moment(this.getCurrentDate());

      if (forward) {
        $(this.$el).fullCalendar('gotoDate', current.add(7, 'days'));
      } else {
        $(this.$el).fullCalendar('gotoDate', current.subtract(7, 'days'));
      }
    }

    jumpToDateClick() {
      const dateRangePicker = this.$jumpToDateEl.data('daterangepicker'),
        currentDate = this.getCurrentDate();

      this.$jumpToDateEl.val(currentDate);

      dateRangePicker.setStartDate(currentDate);
      dateRangePicker.setEndDate(currentDate);

      this.$jumpToDateEl.click();
    }

    insertJumpToDate() {
      const $jumpToDateButton = $('.fc-jumpToDate-button');

      $jumpToDateButton.wrap('<div class="fc-button-group fc-button-group--jump-to-date" />');

      if ($jumpToDateButton.length === 0) {
        return;
      }

      this.$jumpToDateEl = $(`
        <input type="text" class="jump-to-date" name="jump-to-date" id="jump-to-date" value="${this.getCurrentDate()}">
      `).daterangepicker({
        singleDatePicker: true,
        showDropdowns: true,
        locale: {
          format: 'YYYY-MM-DD'
        }
      }).on(
        'change',
        this.jumpToDateElChange.bind(this)
      ).insertAfter($jumpToDateButton);

      $('<label for="jump-to-date"><span class="sr-only">Jump to date</span></label>').insertAfter($jumpToDateButton);
    }

    getCurrentDate(format = 'YYYY-MM-DD') {
      return $(this.$el).fullCalendar('getDate').format(format);
    }

    jumpToDateElChange(el) {
      $(this.$el).fullCalendar('gotoDate', moment($(el.currentTarget).val()));
    }

    fullscreenClick(event) {
      let method = 'show';

      this.isFullscreen = this.isFullscreen ? false : true;

      this.$el.toggleClass('realtime-calendar--fullscreen');
      $('.container').toggleClass('container--fullscreen');
      $(event.currentTarget).toggleClass('fc-state-active');

      if (this.isFullscreen) {
        method = 'hide';
      }

      $('.page-footer, .page-header, .navbar')[method]();

      this.alterHeight();
    }

    getHeight() {
      let height = $(window).height();

      if (this.isFullscreen === false) {
        height -= (this.$el.offset().top + $('.page-footer').outerHeight(true));
      } else {
        height -= 20;
      }

      return height;
    }

    alterHeight() {
      $(this.$el).fullCalendar('option', 'height', this.getHeight());
    }

    setCalendarToCorrectHeight() {
      this.alterHeight();
      $(window).on('resize', this.debounce(this.alterHeight.bind(this), 20));
    }

    debounce(func, wait, immediate) {
      let timeout;

      return () => {
        const context = this,
          args = arguments,
          later = () => {
            timeout = null;
            if (!immediate) func.apply(context, args);
          },
          callNow = immediate && !timeout;

        clearTimeout(timeout);

        timeout = setTimeout(later, wait);

        if (callNow) func.apply(context, args);
      };
    }

  }

  window.GOVUKAdmin.Modules.RealtimeCalendar = RealtimeCalendar;
}
