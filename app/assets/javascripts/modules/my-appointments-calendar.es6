/* global CompanyCalendar */
{
  'use strict';

  class MyAppointmentsCalendar extends CompanyCalendar {
    start(el) {
      this.config = {
        header: {
          right: 'fullscreen sort filter today jumpToDate prev,next'
        },
        customButtons: {
          fullscreen: {
            text: 'Fullscreen',
            click: this.fullscreenClick.bind(this)
          }
        }
      };

      this.isFullscreen = false;

      super.start(el);

      this.$rowHighlighter = $('<div class="calendar-row-highlighter"/>').insertAfter(this.$el);
      this.$rowHighlighterTime = $('<div class="calendar-row-highlighter-time"/>').insertAfter(this.$el);

      this.setCalendarToCorrectHeight();
    }

    showAlert(alertClass) {
      $('.alert')
        .hide()
        .filter(alertClass)
        .show()
        .delay(3000)
        .fadeOut('slow');
    }

    setCalendarToCorrectHeight() {
      this.alterHeight();
      $(window).on('resize', this.debounce(this.alterHeight.bind(this), 20));
    }

    debounce(func, wait, immediate) {
      let timeout;

      return () => {
        const context = this,
          args = arguments,
          later = () => {
            timeout = null;
            if (!immediate) func.apply(context, args);
          },
          callNow = immediate && !timeout;

        clearTimeout(timeout);

        timeout = setTimeout(later, wait);

        if (callNow) func.apply(context, args);
      };
    }

    getHeight() {
      let height = $(window).height();

      if (this.isFullscreen === false) {
        height -= (this.$el.offset().top + $('.page-footer').outerHeight(true));
      } else {
        height -= 20;
      }

      return height;
    }

    alterHeight() {
      this.$el.fullCalendar('option', 'height', this.getHeight());
    }

    styleEvents(event, element) {
      element.removeClass('fc-event--moved fc-event--cancelled');

      if(event.cancelled) {
        element.addClass('fc-event--cancelled');
      }
    }

    fullscreenClick(event) {
      let method = 'show';

      this.isFullscreen = this.isFullscreen ? false : true;

      this.$el.toggleClass('company-calendar--fullscreen');
      $('.container').toggleClass('container--fullscreen');
      $(event.currentTarget).toggleClass('fc-state-active');

      if (this.isFullscreen) {
        method = 'hide';
      }

      $('.page-footer, .breadcrumb, .navbar')[method]();

      this.alterHeight();
    }
  }

  window.GOVUKAdmin.Modules.MyAppointmentsCalendar = MyAppointmentsCalendar;
}
