require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :mail_gun do
    resources :drops, only: :create
  end

  resources :appointments, only: %i(index edit update)

  resources :booking_requests, only: %i(index destroy) do
    resources :activities, only: %i(index create)

    resources :appointments, only: %i(new create)
  end

  root 'booking_requests#index'

  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      resources :booking_requests, only: :create
    end
  end

  mount Sidekiq::Web, at: '/sidekiq', constraint: AuthenticatedUser.new
end
