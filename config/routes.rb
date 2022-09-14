Rails.application.routes.draw do
  devise_for :users, path: 'accounts'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :likes

  devise_scope :user do
    authenticated :user do
      root 'users#feed', as: :authenticated_root
    end
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :comments

  resources :posts do
    resources :comments
  end

  resources :comments do
    resources :comments
  end

  resources :users, only: %i[index show] do
    member do
      get :following, :followers
    end
  end
  resources :relationships, only: %i[create destroy update]

  get :search, to: 'main#search'

  resources :stories
end
