require 'sidekiq/web'

Rails.application.routes.draw do
  resources :appointments, only: %i(index edit update)

  resources :booking_requests, only: :index do
    resources :activities, only: :index

    resources :appointments, only: %i(new create)
  end

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
