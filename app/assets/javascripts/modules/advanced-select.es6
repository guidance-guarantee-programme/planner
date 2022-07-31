/* global PlannerBase, GOVUKAdmin */
{
  'use strict';

  class AdvancedSelect extends PlannerBase {
    start(el) {
      this.config = {
        theme: 'bootstrap',
        templateResult: this.renderTemplate.bind(this),
        allowClear: true,
        placeholder: $(el).data('placeholder')
      };

      super.start(el);

      this.$el.select2(this.config);
      this.$el.on('select2:select', this.handleSelect.bind(this));
      this.$el.on('select2:opening', this.handleOpen.bind(this));
    }

    handleOpen() {
      const cookieValue = GOVUKAdmin.cookie('GuiderFilter');

      if (cookieValue) {
        this.$el.val(JSON.parse(cookieValue).filtered);
        this.$el.trigger('change');
      }
    }

    handleSelect() {
      let itemsToSelect = [];
      const $selectedOptions = this.$el.find(':selected[data-children-to-select]');

      for (let i = 0; i < $selectedOptions.length; i++) {
        const $option = $($selectedOptions[i]);

        $option.prop('selected', false);
        itemsToSelect = itemsToSelect.concat($option.data('childrenToSelect'));
      }

      if (this.$el.val()) {
        this.$el.val(this.$el.val().concat(itemsToSelect));
      } else {
        this.$el.val(itemsToSelect);
      }

      this.$el.trigger('change');
    }

    renderTemplate(state) {
      if (!state.id) { return state.text; }

      let text = state.element ? state.element.text : state.text;

      return $(`<i class="glyphicon glyphicon-user"></i> <span>${text}</span>`);
    }
  }

  window.GOVUKAdmin.Modules.AdvancedSelect = AdvancedSelect;
}
