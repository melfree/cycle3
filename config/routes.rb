Rails.application.routes.draw do
  devise_for :users, :controllers => {:sessions => 'users/sessions',:registrations => 'users/registrations'}
  resources :users, only: [:index,:show]
  
  resources :home, only: [:index]
  resources :deals, only: [:index,:create,:destroy]
  
  get 'guest', to: 'home#guest', as: :guest
  put 'edit_current_user', to: 'users#edit_current_user', as: :edit_current_user
  get 'dashboard', to: 'home#index', as: :dashboard


  root 'home#guest'
end
