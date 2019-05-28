Rails.application.routes.draw do
  root 'stats#show'
  resources :feeds, only: %i[index show]

  namespace :api, defaults: { format: :json } do
    resources :feeds, only: %i[index show]
  end
end
