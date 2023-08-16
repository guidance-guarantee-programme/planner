(function($) {
  'use strict';

  var dateTimePicker = {
    init: function(elem) {
      this.$picker = elem;
      this.config = $.extend(
        true,
        {
          autoUpdateInput: false,
          singleDatePicker: true,
          locale: {
            format: 'DD MMMM YYYY'
          }
        },
        this.$picker.data('config')
      )

      this.$picker.daterangepicker(this.config);

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
