Rails.application.routes.draw do
  resources :booking_requests, only: :index

  root 'booking_requests#index'

  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      resources :booking_requests, only: :create
    end
  end
end
