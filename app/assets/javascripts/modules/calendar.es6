/* global moment, PlannerBase, GOVUKAdmin */

/*eslint-disable no-unused-vars*/
class Calendar extends PlannerBase {
/*eslint-enable no-unused-vars*/
  start(el) {
    const defaultConfig = {
      allDaySlot: false,
      cookieName: el.attr('id') || 'calendar',
      customButtons: {
        jumpToDate: {
          text: 'Jump to date',
          click: this.jumpToDateClick.bind(this)
        }
      },
      buttonText: {
        agendaDay: 'Day',
        timelineDay: 'Timeline',
        today: 'Jump to today',
        month: 'Month',
        week: 'Week'
      },
      defaultDate: moment(el.data('default-date')),
      firstDay: 1,
      height: 'auto',
      maxTime: '18:45:00',
      minTime: '08:30:00',
      schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
      slotLabelFormat: 'H:mm',
      slotEventOverlap: false,
      timeFormat: 'H:mm',
      hiddenDays: [ 0 ], // Sunday
      select: (...args) => this.select(...args),
      viewRender: (...args) => this.viewRender(...args),
      eventRender: (...args) => this.eventRender(...args),
      resourceRender: (...args) => this.resourceRender(...args),
      eventAfterRender: (...args) => this.eventAfterRender(...args),
      eventClick: (...args) => this.eventClick(...args),
      eventDrop: (...args) => this.eventDrop(...args),
      eventResize: (...args) => this.eventResize(...args),
      loading: (...args) => this.loading(...args),
      eventAfterAllRender: (...args) => this.eventAfterAllRender(...args)
    };

    this.config = $.extend(
      true,
      defaultConfig,
      this.config
    );

    super.start(el);

    this.$el.fullCalendar(this.config);

    this.insertJumpToDate();
    this.addAccessibilityImprovements();
  }

  insertLoadingView() {
    if (this.calendarLoadingView) {
      return;
    }

    this.calendarLoadingView = $(`
      <div class="calendar-loading hide">
        <div class="loading-spinner loading-spinner--large">
          <div class="loading-spinner__bounce loading-spinner__bounce--1"></div>
          <div class="loading-spinner__bounce loading-spinner__bounce--2"></div>
          <div class="loading-spinner__bounce"></div>
        </div>
      </div>`);

    this.calendarLoadingView.appendTo($('.fc-view-container'));
  }

  addAccessibilityImprovements() {
    $('.fc-prev-button').append('<span class="sr-only">Previous Date</span>');
    $('.fc-next-button').append('<span class="sr-only">Next Date</span>');
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

  jumpToDateElChange(el) {
    this.$el.fullCalendar('gotoDate', moment($(el.currentTarget).val()));
  }

  viewRender(view) {
    this.setCookieConfig(view);
  }

  setCookieConfig(view) {
    GOVUKAdmin.cookie(
      this.config.cookieName,
      JSON.stringify({
        defaultView: view.name,
        defaultDate: view.calendar.getDate()
      }),
      {
        days: 7
      }
    );
  }

  getCurrentDate(format = 'YYYY-MM-DD') {
    return this.$el.fullCalendar('getDate').format(format);
  }

  loading(isLoading) {
    this.insertLoadingView();

    if (!isLoading && this.calendarLoadingView) {
      clearTimeout(this.loadingTimeout);
      return this.calendarLoadingView.addClass('hide');
    }

    this.loadingTimeout = setTimeout(() => {
      if (isLoading && this.calendarLoadingView) {
        this.calendarLoadingView.removeClass('hide');
      }
    }, 200);
  }

  eventDrop() {

  }

  select() {

  }

  eventRender(event, element) {
    const now = moment(),
      elementId = `event_${event._id}`;

    let end = event.end.clone();

    // account for timezone weirdness
    if (end.subtract(1, 'h') < now) {
      element.addClass('fc--past');
    }

    $(element).attr('id', elementId);

    event.elementId = elementId;
  }

  eventAfterRender() {

  }

  resourceRender() {

  }

  eventClick() {

  }

  eventResize() {

  }

  eventAfterAllRender() {

  }
}
