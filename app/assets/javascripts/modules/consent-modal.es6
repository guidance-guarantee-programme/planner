{
  'use strict';

  class ConsentModal {
    start(el) {
      this.$el = el;
      this.$modal = this.$el.find('.js-consent-modal');
      this.$button = this.$el.find('.js-consent-button');

      this.bindEvents.bind(this)();
    }

    bindEvents() {
      this.$button.on('click', () => { this.$modal.modal() });
    }

  }

  window.GOVUKAdmin.Modules.ConsentModal = ConsentModal;
}
