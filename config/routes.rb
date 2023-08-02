Rails.application.routes.draw do
  resources :feeds, only: :index
  resources :service_instances, only: :index

  root "feeds#index"
end
