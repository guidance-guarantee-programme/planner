Rails.application.routes.draw do
  resources :booking_requests, only: :index

  root 'booking_requests#index'

  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      resources :booking_requests, only: :create
    end
  end

  if Rails.env.production? || Rails.env.staging?
    require 'sidekiq/web'

    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == ENV.fetch('SIDEKIQ_WEB_USERNAME') && password == ENV.fetch('SIDEKIQ_WEB_PASSWORD')
    end

    mount Sidekiq::Web, at: '/sidekiq'
  end
end
