Rails.application.routes.draw do
  root 'home#index'
  
  devise_for :users
  
  resources :users, only: [:index, :show, :edit, :update]

  resources :courses do
    resources :lessons
    resources :enrollments, only: [:new, :create]

    get :my_enrolled, :pending_review, :my_created, on: :collection
  end
  
  resources :enrollments do
    get :students, on: :collection
  end
  
  get 'activities', to: 'home#activities'
  get 'analytics', to: 'home#analytics'
  
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
