Rails.application.routes.draw do
  devise_for :users, :controllers => {:sessions => 'users/sessions',:registrations => 'users/registrations'}
  resources :users, only: [:index,:show]
  
  resources :examples

  resources :messages do
    resources :comments
  end

  root 'examples#index'
end
