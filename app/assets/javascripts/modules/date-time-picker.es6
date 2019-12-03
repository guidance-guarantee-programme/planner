{
  'use strict';

  class DateTimePicker {
    start(el) {
      this.$el = el;
      this.config = {
        format: 'YYYY-MM-DD HH:mm',
        stepping: 5,
        useCurrent: false,
        daysOfWeekDisabled: [0],
        sideBySide: true,
        enabledHours: [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18],
        widgetPositioning: {
          vertical: 'bottom'
        }
      };

      this.init();
    }

    init() {
      this.$el.datetimepicker(this.config);
    }
  }

  window.GOVUKAdmin.Modules.DateTimePicker = DateTimePicker;
}
