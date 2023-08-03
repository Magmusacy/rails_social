Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations', sessions: 'users/sessions' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, only: [:show, :index]
  resources :invitations, only: [:create, :destroy, :update] do
    collection do  
      get "friends"
      get "suggested"
      get "pending"
    end
  end
  
  root "posts#index"
  
  resources :posts do 
    resources :likes, only: [:create, :destroy]
  end

  resources :comments, only: [:create, :destroy] do
    resources :likes, only: [:create, :destroy]
  end
end
