(function($) {
  'use strict';

  var poller = {
    init: function() {
      this.$poller = $('.js-poller');
      this.$messageForm = $('.js-message-form');

      if (this.$poller.length && this.$messageForm.length) {
        this.setLast(this.timestamp());
        this.start();
      }
    },

    start: function() {
      setInterval($.proxy(this.poll, this), this.interval());
    },

    poll: function() {
      $.ajax({ url: this.url(), data: { timestamp: this.getLast() } })
       .always($.proxy(this.handleResponse, this));
    },

    handleResponse: function(data, status, request) {
      if (request.status == 200) {
        this.setLast(this.timestamp());
        this.insertActivity(data);
      }
    },

    setLast: function(value) {
      this._last = value;
    },

    getLast: function() {
      return this._last;
    },

    insertActivity: function(text) {
      var element = $(text);

      if (!document.getElementById(element.attr('id'))) {
        element.hide().prependTo(this.$poller).fadeIn();

        $('.js-no-activities').remove();
      }
    },

    timestamp: function() {
      return new Date().valueOf();
    },

    interval: function() {
      return this.$poller.data('interval');
    },

    url: function() {
      return this.$poller.data('url');
    }
  };

  window.PWPlanner = window.PWPlanner || {};
  window.PWPlanner.poller = poller;

})(jQuery);
