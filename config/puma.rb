rack_env = ENV.fetch('RACK_ENV', 'development')

rackup      DefaultRackup if defined?(DefaultRackup)
environment rack_env
workers     ENV.fetch('WEB_CONCURRENCY', 2) unless rack_env == 'development'
threads     ENV.fetch('MAX_THREADS', 5), ENV.fetch('MAX_THREADS', 5)
port        ENV.fetch('PORT', 3000)

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
