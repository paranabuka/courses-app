Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  resources :users, only: [:index]
  resources :courses

  get 'privacy_policy', to: 'static_pages#privacy_policy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
