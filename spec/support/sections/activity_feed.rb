module Sections
  class ActivityFeed < SitePrism::Section
    sections :activities, Sections::Activity, '.t-activity'

    element :further_activities, '.t-further-activities'
    element :hidden_activities, '.t-hidden-activities'
  end
end
