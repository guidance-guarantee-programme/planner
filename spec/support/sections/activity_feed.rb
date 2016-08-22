module Sections
  class ActivityFeed < SitePrism::Section
    sections :activities, Sections::Activity, '.t-activity'
  end
end
