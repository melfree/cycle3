Rails.application.routes.draw do
  resources :favorites
  devise_for :users, :controllers => {:sessions => 'users/sessions',:registrations => 'users/registrations'}
  
  resources :users, only: [:index,:show]
  
  resources :deals, only: [:index]
  
  resources :messages, only: [:create]
  
  get 'dashboard', to: 'deals#index', as: :dashboard
  
  get 'guest', to: 'home#guest', as: :guest
  put 'edit_current_location', to: 'users#edit_current_location', as: :edit_current_location
  put 'edit_current_user', to: 'users#edit_current_user', as: :edit_current_user
  put 'edit_current_deal', to: 'deals#edit_current_deal', as: :edit_current_deal  


  root 'home#guest'
end
