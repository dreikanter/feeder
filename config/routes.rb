Rails.application.routes.draw do
  resources :feeds, only: %i[index show]

  namespace :api, defaults: { format: :json } do
    resources :feeds, only: %i[index show]
  end

  root 'layout#show'
  get '*path', to: 'layout#show'
end
