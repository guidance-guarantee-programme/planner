/* global moment */

(function($) {
  'use strict';

  var dateTimePicker = {
    init: function() {
      this.$picker = $('.js-date-time-picker');

      this.$picker.daterangepicker({
        singleDatePicker: true,
        locale: {
          format: 'DD MMMM YYYY'
        }
      });
    }
  };

  window.PWPlanner = window.PWPlanner || {};
  window.PWPlanner.dateTimePicker = dateTimePicker;

})(jQuery);
