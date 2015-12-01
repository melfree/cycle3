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

  post 'addfavorite/:id', to: "favorites#create", as: :create_favorite
  delete 'deletefavorite/:id', to: "favorites#destroy", as: :delete_favorite

  post 'make_deal/:id', to: 'deals#make_deal', as: :make_deal
  
  post 'complete_deal', to: 'deals#complete_deal', as: :complete_deal
  post 'cancel_deal', to: 'deals#cancel_deal', as: :cancel_deal
  post 'cancel_search', to: 'users#cancel_search',  as: :cancel_search

  root 'home#guest'
end
