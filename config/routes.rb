Rails.application.routes.draw do
  devise_for :users, :controllers => {registrations: 'registrations'}

  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"

  resources :posts do
    resources :comments
    member do
      post :like
      post :dislike
    end
  end

  resources :users_profile, only: [:show, :update, :edit]

  resources :friend_requests do
    member do
      post :accept
      post :reject
    end
    collection do
      get :search_friend
    end
  end
  resources :notifications
  resources :friends_list, only: [:index, :destroy]
  # resources :search_friends, only: [:search]
end
