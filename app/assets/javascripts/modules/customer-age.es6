/* global moment */
{
  'use strict';

  class CustomerAge {
    start(el) {
      this.$el = el;

      this.$day = this.$el.find('.js-dob-day');
      this.$month = this.$el.find('.js-dob-month');
      this.$year = this.$el.find('.js-dob-year');
      this.$output = $(`#${this.$el.data('output-id')}`);

      this.bindEvents();
    }

    bindEvents() {
      this.$day.on('change input', this.renderCustomerAge.bind(this));
      this.$month.on('change input', this.renderCustomerAge.bind(this));
      this.$year.on('change input', this.renderCustomerAge.bind(this));
      this.renderCustomerAge();
    }

    padNumber(val) {
      return (`00${val}`).substr(-2, 2);
    }

    renderCustomerAge() {
      this.emptyAge();

      let day = parseInt(this.$day.val()),
        month = parseInt(this.$month.val()),
        year = parseInt(this.$year.val()),
        today = moment(),
        inputDate = null,
        age = null;

      if (!day || !month || !year || year < 1900 || year >= today.format('Y')) {
        return;
      }

      day = this.padNumber(day);
      month = this.padNumber(month);
      inputDate = moment(`${year}-${month}-${day}`);
      age = Math.floor(today.diff(inputDate, 'year'));

      if (age) {
        this.$output.html(`<b>${age}</b> years old`);
      }
    }

    emptyAge() {
      this.$output.html('');
    }
  }

  window.GOVUKAdmin.Modules.CustomerAge = CustomerAge;
}
