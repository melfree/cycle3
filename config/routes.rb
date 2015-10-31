Rails.application.routes.draw do
  devise_for :users, :controllers => {:sessions => 'users/sessions',:registrations => 'users/registrations'}
  resources :users, only: [:index,:show]
  
  resources :home, only: [:index]
  put 'edit_status', to: 'home#edit_status', as: :edit_status

  resources :messages do
    resources :comments
  end

  root 'home#index'
end
