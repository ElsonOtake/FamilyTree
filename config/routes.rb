Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'users/confirmations' }
  resources :people do
    resources :couples do
      resources :children
    end
    get 'search_child', on: :collection
    get 'search_mate', on: :collection
    patch 'change/:locale', to: 'people#change', as: 'locale_change'
    patch 'change_unidentified/:locale', on: :collection, to: 'people#change_unidentified', as: 'locale_change_unidentified'
  end
  resources :users do
    get 'roles', on: :collection
    patch 'role_update', on: :member
  end
  resources :couples, only: [:index, :show, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "people#index"
end
