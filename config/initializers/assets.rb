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

Rails.application.config.assets.precompile << %w(moj.slot-picker/dist/stylesheets/**/*.png
                                                 moj.slot-picker/dist/stylesheets/moj.slot-picker.ap
                                                 moj.slot-picker/dist/stylesheets/moj.date-slider.ap)
