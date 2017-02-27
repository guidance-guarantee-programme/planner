(function($) {
  'use strict';

  var poller = {
    init: function() {
      this.$poller = $('.js-poller');
      this.$messageForm = $('.js-message-form');
      this.pollingTimeout = 1000 * 60 * 60; // 1 hour

      if (this.$poller.length && this.$messageForm.length) {
        this.setLast(this.timestamp());
        this.bindEvents();
        this.start();
      }
    },

    pageVisibilitySupported: function() {
      return 'hidden' in document;
    },

    bindEvents: function() {
      if (this.pageVisibilitySupported()) {
        $(document).on('visibilitychange', this.handleVisibilityChange.bind(this));
      }
    },

    handleVisibilityChange: function() {
      return this.isPageHidden() ? this.stop() : this.start();
    },

    isPageHidden: function() {
      return document['hidden'];
    },

    start: function() {
      this.pollingTimer = setInterval($.proxy(this.poll, this), this.interval());
      this.timeoutTimer = setTimeout($.proxy(this.stop, this), this.pollingTimeout);
    },

    stop: function() {
      clearInterval(this.pollingTimer);
      clearTimeout(this.timeoutTimer);
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
