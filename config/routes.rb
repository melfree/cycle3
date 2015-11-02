Rails.application.routes.draw do
  devise_for :users, :controllers => {:sessions => 'users/sessions',:registrations => 'users/registrations'}
  resources :users, only: [:index,:show]
  
  resources :home, only: [:index]
  resources :deals, only: [:create,:destroy]
  
  get 'guest', to: 'home#guest', as: :guest
  put 'edit_status', to: 'home#edit_status', as: :edit_status
  get 'dashboard', to: 'home#index', as: :dashboard


  root 'home#guest'
end
