/* global PlannerBase */
{
  'use strict';

  class PostcodeLookup extends PlannerBase {
    start(el) {
      super.start(el);
      this.$apiKey = el.data('postcode-api-key');
      this.$lookupInput = el.data('lookup-input');
      this.$lookupButton = el.data('lookup-button');
      this.$resultsContainer = el.data('results-container');
      this.$outputFieldPrefix = el.data('output-field-prefix');

      this.initPostcodeLookup();
    }

    insertHTML() {
      this.$el.after(this.template());
    }

    initPostcodeLookup() {
      this.$el.setupPostcodeLookup({
        address_search: 20,
        api_key: this.$apiKey,
        input: this.$lookupInput,
        button: this.$lookupButton,
        dropdown_class: 'form-control input-md-3',
        dropdown_container: this.$resultsContainer,
        output_fields: {
          line_1: `${this.$outputFieldPrefix}_address_line_one`,
          line_2: `${this.$outputFieldPrefix}_address_line_two`,
          line_3: `${this.$outputFieldPrefix}_address_line_three`,
          post_town: `${this.$outputFieldPrefix}_town`,
          postcode: `${this.$outputFieldPrefix}_postcode`
        }
      });
    }
  }

  window.GOVUKAdmin.Modules.PostcodeLookup = PostcodeLookup;
}
