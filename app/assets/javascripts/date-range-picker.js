/* global moment */

(function($) {
  'use strict';

  var dateRangePicker = {
    init: function() {
      this.$picker = $('.js-date-range-picker');
      this.config = {
        locale: {
          format: 'DD/MM/YYYY',
          cancelLabel: 'Clear'
        },
        autoUpdateInput: false,
        ranges: {
          'Today': [moment(), moment()],
          'Tomorrow': [moment().add(1, 'days'), moment().add(1, 'days')],
          'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
          'Last 7 Days': [moment().subtract(6, 'days'), moment()],
          'Last 30 Days': [moment().subtract(29, 'days'), moment()],
          'This Month': [moment().startOf('month'), moment().endOf('month')],
          'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        }
      };

      $.extend(true, this.config, this.$picker.data('config'));

      this.$picker.daterangepicker(this.config);

      this.$picker.on('apply.daterangepicker', function(ev, picker) {
        $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
      });

      this.$picker.on('cancel.daterangepicker', function() {
        $(this).val('');
      });
    }
  };

  window.PWPlanner = window.PWPlanner || {};
  window.PWPlanner.dateRangePicker = dateRangePicker;

})(jQuery);
