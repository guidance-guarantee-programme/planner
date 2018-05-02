/* global PlannerBase, Pusher */

{
  'use strict';

  class DropNotifications extends PlannerBase {
    start(el) {
      super.start(el);
      this.setupPusher();
    }

    setupPusher() {
      const channel = Pusher.instance.subscribe('drop_notifications');

      channel.bind(this.config.event, this.handlePushEvent.bind(this));

      $(window).on('beforeunload', () => {
        channel.unbind(this.config.event, this.handlePushEvent.bind(this));
      });
    }

    handlePushEvent(payload) {
      jQuery.growl.error(payload);
    }
  }

  window.GOVUKAdmin.Modules.DropNotifications = DropNotifications;
}
