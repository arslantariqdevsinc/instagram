Rails.application.routes.draw do
  devise_for :users, path: 'accounts'

  resources :likes, only: %i[create destroy]

  devise_scope :user do
    authenticated :user do
      root 'users#feed', as: :authenticated_root
    end
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  resources :comments, only: %i[edit destroy]

  resources :posts do
    resources :comments
  end
  resources :stories, except: [:index]

  resources :users, only: %i[index show] do
    member do
      get :following, :followers
      get :stories
    end
  end
  resources :relationships, only: %i[create destroy update]

  get :search, to: 'main#search'
end
