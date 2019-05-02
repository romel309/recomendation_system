Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :noticias


  get "user", to: "users#index"
  get 'user/:id', to: 'users#show'
  get "movies", to: "movies#index"
  get "usuario", to: "users#index"
  
  root to: "pages#inicio"
  
  devise_for :users, controllers: {
      sessions: 'users/sessions',
      confirmations: 'users/confirmations',
      passwords: 'users/passwords',
      registrations: 'users/registrations',
      unlocks: 'users/unlocks',
      invitations: 'users/invitations'
  }
  
  
end

