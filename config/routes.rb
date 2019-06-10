Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :feeds, only: %i[index show] do
      resource :activity, only: :show, controller: :activity
      resources :posts, only: :index
      resources :updates, only: :index
    end

    resource :activity, only: :show, controller: :activity
    resources :batches, only: :index
    resources :posts, only: :index
    resources :updates, only: :index
  end

  # Generate path helpers for client-side routing
  resources :feeds, only: %i[index show], controller: :layout, action: :show
  resources :posts, only: :index, controller: :layout, action: :show
  resources :updates, only: :index, controller: :layout, action: :show

  root 'layout#show'
  get '*path', to: 'layout#show'
end
