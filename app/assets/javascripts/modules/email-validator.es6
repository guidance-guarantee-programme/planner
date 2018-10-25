(function() {
  'use strict';

  class EmailValidator {
    constructor(component) {
      this.$component = component;

      this.$component.mailgun_validator({
        api_key: 'pubkey-315b5fdbcd4d698bdef6688c47ed0f12',
        in_progress: this.showLoadingSpinner.bind(this),
        success: this.onSuccess.bind(this),
        error: this.onError.bind(this)
      });

      this.insertSuggestionContainer();
      this.insertLoadingSpinner();
    }

    onSuccess(data) {
      this.hideLoadingSpinner();

      if (!data.is_valid || data.did_you_mean) {
        this.showSuggestion(data.is_valid, data.did_you_mean);
      } else {
        this.clearSuggestion();
      }
    }

    onError(message) {
      this.hideLoadingSpinner();
      this.$suggestionContainer.html(message);
    }

    insertLoadingSpinner() {
      if (this.$loadingSpinner) {
        return;
      }

      this.$loadingSpinner = $('<div class="ajax-loader ajax-loader--24px hidden"></div>');
      this.$loadingSpinner.insertAfter(this.$component);
    }

    showLoadingSpinner() {
      this.clearSuggestion();
      this.$loadingSpinner.removeClass('hidden');
    }

    hideLoadingSpinner() {
      this.$loadingSpinner.addClass('hidden');
    }

    insertSuggestionContainer() {
      if (this.$suggestionContainer) {
        return;
      }

      this.$suggestionContainer = $('<div class="help-block email-suggestion" aria-live="polite" />');
      this.$suggestionContainer.insertAfter(this.$component);
    }

    showSuggestion(isValid, didYouMean) {
      let messages = [],
          message;

      if (!isValid) {
        messages.push("that doesn't look like a valid address");
      }

      if (didYouMean) {
        messages.push(
          `did you mean
          <a class="js-populate-suggested-email">${didYouMean}</a>?
        `);
      }

      message = messages.join(', ');
      message = message.charAt(0).toUpperCase() + message.slice(1);

      this.$suggestionContainer.html(message);

      $('.js-populate-suggested-email').click((event) => {
        event.preventDefault();
        this.$component.val(event.target.innerHTML);
        this.clearSuggestion();
      });
    }

    clearSuggestion() {
      this.$suggestionContainer.empty();
    }
  }

  window.PWPlanner = window.PWPlanner || {};
  window.PWPlanner.EmailValidator = EmailValidator;
})();
