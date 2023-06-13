Rails.application.routes.draw do
  resources :feeds, only: :index

  root "feeds#index"
end
