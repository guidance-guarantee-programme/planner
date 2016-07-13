#!/usr/bin/env puma

rackup      DefaultRackup
daemonize   false
environment ENV.fetch('RACK_ENV', 'development')
workers     ENV.fetch('WEB_CONCURRENCY', 2)
threads     ENV.fetch('MAX_THREADS', 5), ENV.fetch('MAX_THREADS', 5)
port        ENV.fetch('PORT', 3000)

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
