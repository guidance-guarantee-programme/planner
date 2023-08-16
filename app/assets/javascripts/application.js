//= require moment
//= require fullcalendar
//= require fullcalendar-scheduler
//= require alertify
//= require bootstrap-daterangepicker
//= require eonasdan-bootstrap-datetimepicker
//= require growl
//= require pusher
//= require planner-base
//= require qTip2
//= require select2
//= require jquery.postcodes/dist/postcodes.js
//= require_tree .

PWPlanner.poller.init();
PWPlanner.dateRangePicker.init();

$('.js-date-time-picker').each(function() {
  var $component = $(this);
  new PWPlanner.dateTimePicker.init($component); // jshint ignore:line
});
