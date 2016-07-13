Rails.application.routes.draw do
  get 'appointments/index'

  get 'appointments/show'

  root 'booking_requests#index'

  get 'booking_requests/index'
  get 'booking_requests/show'

  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      resources :booking_requests, only: :create
    end
  end

  mount GovukAdminTemplate::Engine, at: '/style-guide' if Rails.env.development?
end
