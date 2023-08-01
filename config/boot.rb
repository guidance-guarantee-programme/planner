ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
ENV['RAILS_ENV'] ||= 'development'

require 'bundler/setup' # Set up gems listed in the Gemfile.

if %w(development test).include?(ENV.fetch('RAILS_ENV'))
  require 'bootsnap'

  # These features are Mac only for the timebeing
  DARWIN = `uname`.chomp == 'Darwin'

  Bootsnap.setup(
    cache_dir: 'tmp/cache',
    development_mode: true,
    load_path_cache: true,
    compile_cache_iseq: DARWIN,
    compile_cache_yaml: DARWIN
  )
end
