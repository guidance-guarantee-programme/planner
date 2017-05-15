{
  'use strict';

  class BookingRequestState {
    start(el) {
      this.$el = el;
      this.$modal = this.$el.find('.js-booking-request-state-modal');
      this.$changeStateButton = this.$el.find('.js-booking-request-change-status-button');

      this.bindEvents.bind(this)();
    }

    bindEvents() {
      this.$changeStateButton.on('click', () => { this.$modal.modal() });
    }

  }

  window.GOVUKAdmin.Modules.BookingRequestState = BookingRequestState;
}
