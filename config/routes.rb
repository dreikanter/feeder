Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :feeds, only: %i[index show], param: :name do
      resource :activity, only: :show, controller: :activity
      resources :posts, only: :index
      resources :updates, only: :index
    end

    resource :activity, only: :show, controller: :activity
    resources :batches, only: :index
    resources :posts, only: :index
    resources :updates, only: :index
  end

  resources :feeds, only: %i[index show],
    controller: :layout, action: :show, param: :name

  resources :posts, only: :index, controller: :layout, action: :show
  resources :updates, only: :index, controller: :layout, action: :show

  root 'layout#show'

  get :about, controller: :layout, action: :show

  # Handle 404
  get '*path', to: 'layout#show'
end
