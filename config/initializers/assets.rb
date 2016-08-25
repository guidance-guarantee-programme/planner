# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.paths << Rails.root.join(
  'vendor',
  'assets',
  'bower_components',
  'moj.slot-picker',
  'dist',
  'stylesheets',
  'images'
)

Rails.application.config.assets.paths << Rails.root.join(
  'vendor',
  'assets',
  'bower_components',
  'moj.slot-picker',
  'vendor'
)

Rails.application.config.assets.precompile += %w( moj.slot-picker/dist/stylesheets/**/*.png
                                                  fullcalendar/dist/fullcalendar.css
                                                  fullcalendar/dist/fullcalendar.print.css
                                                  fullcalendar-scheduler/dist/scheduler.css
                                                  moment/moment.js
                                                  fullcalendar/dist/fullcalendar.js
                                                  fullcalendar-scheduler/dist/scheduler.js
                                                  scheduler.js
                                                  jquery-sortable.js)
