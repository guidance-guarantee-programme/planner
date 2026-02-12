require 'sidekiq/web'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  resources :sms_cancellations, only: :create

  namespace :mail_gun do
    resources :drops, only: :create
  end

  resources :my_appointments, only: :index

  resources :users, only: :update

  resources :appointments, only: %i(index edit update) do
    resource :cancel, only: :create
    resource :process, only: :create
    resources :changes, only: :index

    resource :reschedule, only: %w(create show)
  end

  resources :booking_requests, only: %i(index update) do
    resources :activities, only: %i(index create)

    resources :appointments, only: %i(new create)

    resource :postal_address, only: %i(edit update)

    resource :confirmation, only: :create
    resource :video_confirmation, only: :create

    resource :consent, only: %i(update show)
  end

  resources :schedules, only: :index

  resources :locations, only: :index

  resources :realtime_bookable_slots, only: [] do
    post :bsl, on: :member, to: 'bsl#create'
    delete :bsl, on: :member, to: 'bsl#destroy'
  end

  scope '/locations/:location_id' do
    resources :realtime_bookable_slots, only: %w(index create destroy) do
      delete 'future', on: :collection
    end
    resources :realtime_bookable_slot_copies, only: %w(new create) do
      post 'preview', on: :collection
    end
    resources :realtime_bookable_slot_lists, only: :index
    resources :realtime_appointments, only: :index
    resources :guiders, only: :index
  end

  namespace :agent, path: '/locations/:location_id' do
    resources :booking_requests, only: %i(new create show) do
      post 'preview', on: :collection
    end
  end

  namespace :agent, path: '/agents' do
    resources :booking_requests, only: :index, as: :search
    resources :appointments, only: %i(edit update)
  end

  namespace :booking_manager, path: '/locations/:location_id' do
    resources :appointments, only: %i(new create show) do
      post 'preview', on: :collection
    end
  end

  namespace :admin, path: '/admin' do
    resource :search, only: :show
  end

  root 'home#index'

  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      resources :searches, only: :index
      resources :booking_requests, only: :create do
        patch :batch_reassign, on: :collection
      end
    end

    namespace :v2 do
      get '/locations/:location_id/bookable_slots', to: 'bookable_slots#index', as: :bookable_slots
    end
  end

  mount Sidekiq::Web, at: '/sidekiq', constraints: AuthenticatedUser.new
end
# rubocop:enable Metrics/BlockLength
