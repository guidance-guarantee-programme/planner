require 'sidekiq/web'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  resources :sms_cancellations, only: :create

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

    resource :postal_address, only: %i(edit update)

    resource :confirmation, only: :create
  end

  resources :schedules, only: %i(index new create) do
    resources :bookable_slots, only: [] do
      collection do
        get 'edit'
        put 'update'
      end
    end
  end

  scope '/locations/:location_id' do
    resources :bookable_slots, only: :index
  end

  namespace :agent, path: '/locations/:location_id' do
    resources :booking_requests, only: %i(new create show) do
      post 'preview', on: :collection
    end
  end

  namespace :agent, path: '/agents' do
    resources :booking_requests, only: :index, as: :search
  end

  namespace :admin, path: '/admin' do
    resource :search, only: :show
  end

  root 'home#index'

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
