/* global moment */

(function($) {
  'use strict';

  var picker = {
    init: function() {
      this.$picker = $('.js-picker');

      this.$picker.daterangepicker({
        ranges: {
          'Today': [moment(), moment()],
          'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
          'Last 7 Days': [moment().subtract(6, 'days'), moment()],
          'Last 30 Days': [moment().subtract(29, 'days'), moment()],
          'This Month': [moment().startOf('month'), moment().endOf('month')],
          'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        },
        locale: {
          format: 'DD/MM/YYYY',
          cancelLabel: 'Clear'
        },
        autoUpdateInput: false
      });

      this.$picker.on('apply.daterangepicker', function(ev, picker) {
        $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
      });

      this.$picker.on('cancel.daterangepicker', function() {
        $(this).val('');
      });
    }
  };

  window.PWPlanner = window.PWPlanner || {};
  window.PWPlanner.picker = picker;

})(jQuery);
