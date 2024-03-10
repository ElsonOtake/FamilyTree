Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'users/confirmations' }
  resources :people do
    resources :couples, only: [:new, :edit, :create, :update] do
      resources :children
    end
    patch 'change/:locale', to: 'people#change', as: 'locale_change'
  end
  resources :couples, only: [:index, :show, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "people#index"

  # search
  namespace :search do
    namespace :people do
      post "first_letter", :as => "first_letter"
      post "name", :as => "name"
    end
  end
end
