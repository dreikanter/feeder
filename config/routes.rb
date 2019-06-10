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

  root 'layout#show'
  get '*path', to: 'layout#show'
end
