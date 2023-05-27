Rails.application.routes.draw do
  devise_for :users
  resources :people do
    resources :couples
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "people#index"

  # search
  namespace :search do
    namespace :users do
      post "first_letter", :as => "first_letter"
      post "name", :as => "name"
    end
  end
end
