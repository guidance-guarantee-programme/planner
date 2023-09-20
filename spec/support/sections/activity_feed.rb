module Sections
  class ActivityFeed < SitePrism::Section
    sections :activities, Sections::Activity, '.t-activity'

    element :message, '.t-message'
    element :submit, '.t-submit-message'

    element :further_activities, '.t-further-activities'
    element :hidden_activities, '.t-hidden-activities'

    def stop_polling!
      execute_script('window.PWPlanner.poller.stop();')
    end
  end
end
