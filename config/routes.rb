Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :posts
  resources :users, only: [:show, :index]
  resources :comments, only: [:create, :destroy]
  root "posts#index"
end
