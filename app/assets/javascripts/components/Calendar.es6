/* global require */
{
  'use strict';

  const calendarConfigs = {
    'default': require('components/calendars/default.es6'),
    'guider-schedule': require('components/calendars/guider-schedule.es6')
  };

  class CalendarResource {
    constructor(count, data = {}) {
      this.id = `resource_${data.id}`;
      this.title = data.title;
      this.enabled = true;
      this.eventClassName = `calendar-filters__key--${count}`;
    }
  }

  class CalendarEvent {
    constructor(data = {}) {
      this.id = data.id;
      this.resourceId = `resource_${data.guiderId}`;
      this.locationId = `location_${data.locationId}`;
      this.locationName = data.locationName;
      this.start = data.start;
      this.name = data.name;
      this.guiderName = data.guiderName;
      this.status = data.status;
      this.url = data.url;
      this.enabled = true;
    }
  }

  class Calendar {
    constructor(config = {}) {
      this.config = $.extend(
        true,
        calendarConfigs.default,
        config,
        calendarConfigs[config.type]
      );

      this.$el = $(this.config.selector);

      this.setupResources();
      this.setupEvents();
      this.setupFilters();
      this.init();
    }

    init() {
      this.$el.fullCalendar(this.config.fullCalendar);
    }

    setupResources() {
      this.resources = [];

      var i = 1;
      for (var resource of this.config.resources) {
        this.resources.push(new CalendarResource(i, resource));
        i++;
      }

      this.config.fullCalendar.resources = (callback) => {
        callback(this.resources.filter(resource => {
          return resource.enabled === true;
        }));
      };
    }

    setupEvents() {
      this.events = [];

      for (var event of this.config.events) {
        this.events.push(new CalendarEvent(event));
      }

      this.config.fullCalendar.events = (start, end, timezone, callback) => {
        callback(this.events.filter(event => {
          return event.enabled === true;
        }));
      };
    }

    setupFilters() {
      $('#calendar-filters').find('input[type=checkbox]').on(
        'change',
        this.filter.bind(this)
      );
    }

    filter(el) {
      const target = $(el.currentTarget),
      id = target.attr('id'),
      isChecked = target.is(':checked');

      for (var resource of this.resources) {
        if (resource.id === id) {
          resource.enabled = isChecked;
        }
      }

      for (var event of this.events) {
        if (event.locationId === id || event.resourceId === id) {
          event.enabled = isChecked;
        }
      }

      this.refreshCalendar();
    }

    refreshCalendar() {
      this.$el.fullCalendar('refetchResources');
      this.$el.fullCalendar('refetchEvents');
    }
  }

  window.PWPLAN = window.PWPLAN || {};
  window.PWPLAN.Calendar = Calendar;
}
