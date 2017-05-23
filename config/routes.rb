require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :mail_gun do
    resources :drops, only: :create
  end

  resources :users, only: :update

  resources :appointments, only: %i(index edit update) do
    resources :changes, only: :index
  end

  resources :booking_requests, only: %i(index update) do
    resources :activities, only: %i(index create)

    resources :appointments, only: %i(new create)
  end

  resources :schedules, only: %i(index new create)

  root 'booking_requests#index'

  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      get '/locations/:location_id/bookable_slots',
          to: 'bookable_slots#index',
          as: :bookable_slots

      resources :booking_requests, only: :create do
        patch :batch_reassign, on: :collection
      end
    end
  end

  mount Sidekiq::Web, at: '/sidekiq', constraints: AuthenticatedUser.new
end
