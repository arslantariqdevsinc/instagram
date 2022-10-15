Rails.application.routes.draw do
  devise_for :users, path: 'accounts'

  devise_scope :user do
    authenticated :user do
      root 'feeds#show', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :users, only: %i[index show] do
    member do
      get :following, :followers
    end

    resources :stories, only: %i[new index show create]
  end

  resources :stories, only: :destroy

  resources :posts do
    resources :comments, shallow: true, except: %i[new index show]
    resources :likes, only: %i[create destroy]
  end

  resources :relationships, only: %i[create destroy update]

  get :search, to: 'main#search'
end
