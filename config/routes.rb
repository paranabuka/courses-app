Rails.application.routes.draw do
  root 'home#index'
  
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  resources :users, only: [:index, :show, :edit, :update]

  resources :courses do
    resources :lessons, except: [:index] do
      resources :comments, except: [:index]

      put :sort
      
      member do
        delete :delete_media
      end
    end
    
    resources :enrollments, only: [:new, :create]

    get :my_enrolled, :pending_review, :my_created, :pending_approval, on: :collection

    member do
      get :analytics
      patch :approve
      patch :reject
    end
  end
  
  resources :enrollments do
    get :students, on: :collection
  end
  
  get 'activities', to: 'home#activities'
  get 'analytics', to: 'home#analytics'
  
  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'courses_popularity'
    get 'money_makers'
  end

  get 'privacy_policy', to: 'static_pages#privacy_policy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
