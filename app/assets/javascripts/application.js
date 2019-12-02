//= require moment
//= require fullcalendar
//= require fullcalendar-scheduler
//= require alertify
//= require bootstrap-daterangepicker
//= require eonasdan-bootstrap-datetimepicker
//= require mailgun-validator-jquery
//= require growl
//= require pusher
//= require planner-base
//= require_tree .

PWPlanner.poller.init();
PWPlanner.dateRangePicker.init();
PWPlanner.dateTimePicker.init();
PWPlanner.postcodeLookup.init();

$('[data-email-validation]').each(function() {
  'use strict';

  new PWPlanner.EmailValidator($(this));
});
