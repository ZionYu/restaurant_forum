Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "restaurants#index"
  resources :restaurants, only: [:index, :show] do
    resources :comments, only: [:create, :destroy]

    collection do
      get :feeds
    end

    member do
      get :dashboard

      post :favorite
      post :unfavorite
    end
    
  end

  resources :categories, only: [:show]
  resources :users, only: [:show, :edit, :update]

  namespace :admin do
    root "restaurants#index"
    resources :restaurants
    resources :categories
  end
end
