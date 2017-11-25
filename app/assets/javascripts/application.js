//= require jquery
//= require moment
//= require fullcalendar
//= require bootstrap-daterangepicker
//= require mailgun-validator-jquery
//= require_tree .

PWPlanner.poller.init();
PWPlanner.dateRangePicker.init();
PWPlanner.dateTimePicker.init();
PWPlanner.postcodeLookup.init();

$('[data-email-validation]').each(function() {
  'use strict';

  new PWPlanner.EmailValidator($(this));
});
