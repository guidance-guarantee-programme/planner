{
  'use strict';

  class ReschedulingModal {
    start(el) {
      this.$el = el;
      this.$modal = this.$el.find('.js-rescheduling-modal');
      this.$button = this.$el.find('.js-reschedule-button');

      this.bindEvents.bind(this)();
    }

    bindEvents() {
      this.$button.on('click', () => { this.$modal.modal() });
    }

  }

  window.GOVUKAdmin.Modules.ReschedulingModal = ReschedulingModal;
}
