(function($) {
  'use strict';

  var poller = {
    init: function() {
      this.$poller = $('.js-poller');

      if (this.$poller.length) {
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
      $(text).hide().prependTo(this.$poller).fadeIn();
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
