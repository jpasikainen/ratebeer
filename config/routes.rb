Rails.application.routes.draw do
  resources :styles
  resources :memberships
  resources :beer_clubs
  resource :session, only: [:new, :create, :destroy]
  resources :users do
    post 'ban', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :ratings, only: [:index, :new, :create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  get 'places', to: 'places#index'
  post 'places', to: 'places#search'
  resources :places, only: [:index, :show]

  root "breweries#index"
end
