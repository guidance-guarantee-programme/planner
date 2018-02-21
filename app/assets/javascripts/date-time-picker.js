(function($) {
  'use strict';

  var dateTimePicker = {
    init: function() {
      this.$picker = $('.js-date-time-picker');
      this.config = $.extend(
        true,
        {
          singleDatePicker: true,
          locale: {
            format: 'DD MMMM YYYY'
          }
        },
        this.$picker.data('config')
      )

      this.$picker.daterangepicker(this.config);
      this.bindEvents();
    },

    bindEvents: function() {
      if (this.config.autoUpdateInput == false) {
        this.$picker.bind('apply.daterangepicker', {
          config: this.config,
          p: this.$picker
        }, function(ev, picker) {
          ev.data.p.val(picker.startDate.format(ev.data.config.locale.format));
        });

        this.$picker.bind('cancel.daterangepicker', function(ev, picker) {
          picker.val('');
        });
      }
    }
  };

  window.PWPlanner = window.PWPlanner || {};
  window.PWPlanner.dateTimePicker = dateTimePicker;

})(jQuery);
