require 'sidekiq/web'

Rails.application.routes.draw do
  get 'administrators/index'
  get 'administrators/slots'
  get 'administrators/groups'

  resources :appointments, only: %i(index edit update)

  resources :booking_requests, only: :index do
    resources :appointments, only: %i(new create)
  end

  get 'appointments/scheduler', to: 'appointments#scheduler'

  root 'booking_requests#index'

  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      resources :booking_requests, only: :create
    end
  end

  mount Sidekiq::Web, at: '/sidekiq', constraint: AuthenticatedUser.new

  if Rails.application.config.mount_javascript_test_routes
    mount JasmineRails::Engine => '/specs'
    mount JasmineFixtures => '/spec/javascripts/fixtures'
  end
end
