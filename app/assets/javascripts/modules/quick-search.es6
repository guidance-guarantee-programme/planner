{
  'use strict';

  class QuickSearch {
    start(el) {
      this.$el = $(el);
      this.$button = this.$el.find('.js-quick-search-button');
      this.$input = this.$el.find('.js-quick-search-input');

      this.bindEvents();
    }

    bindEvents() {
      this.$button.on('click', () => {
        setTimeout(() => this.$input.focus(), 0); // next tick
      });
    }
  }

  window.GOVUKAdmin.Modules.QuickSearch = QuickSearch;
}
