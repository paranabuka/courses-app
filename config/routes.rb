Rails.application.routes.draw do
  root 'home#index'
  
  get 'activities', to: 'home#activities'
  
  devise_for :users
  
  resources :users, only: [:index, :show, :edit, :update]
  resources :courses do
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end
  resources :enrollments

  get 'privacy_policy', to: 'static_pages#privacy_policy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
