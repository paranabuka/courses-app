Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users, only: [:index, :show, :edit, :update]

  resources :courses, except: [:edit, :update] do
    resources :lessons, except: [:index] do
      resources :comments, except: [:index]

      put :sort

      member do
        delete :delete_media
      end
    end

    resources :enrollments, only: [:new, :create] do
      get :checkout_success, on: :collection
    end

    resources :course_wizard, controller: 'courses/course_wizard'

    get :my_enrolled, :pending_review, :my_created, :pending_approval, on: :collection

    member do
      get :analytics
      patch :approve
      patch :reject
    end
  end

  resources :enrollments do
    get :students, on: :collection
    get :certificate, on: :member
  end

  get 'activities', to: 'home#activities'
  get 'analytics', to: 'home#analytics'

  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'courses_popularity'
    get 'money_makers'
  end

  resources :tags, only: [:index, :create, :destroy]

  get 'privacy_policy', to: 'static_pages#privacy_policy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
