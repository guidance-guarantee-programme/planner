Rails.application.routes.draw do
  root 'booking_requests#index'

  get 'booking_requests/index'
  get 'booking_requests/show'
  get 'booking_requests/scheduler'

  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      resources :booking_requests, only: :create
    end
  end

  mount GovukAdminTemplate::Engine, at: '/style-guide' if Rails.env.development?
end
