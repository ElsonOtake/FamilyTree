Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'users/confirmations' }
  resources :people do
    resources :couples do
      resources :children
    end
    get 'download', on: :collection
    get 'search_child', on: :collection
    get 'search_mate', on: :collection
  end
  resources :users do
    get 'roles', on: :collection
    patch 'role_update', on: :member
    patch 'change/:locale', to: 'users#change', as: 'locale_change'
    patch 'change_unidentified/:locale', on: :collection, to: 'users#change_unidentified', as: 'locale_change_unidentified'
  end
  resources :roles, only: [:index]
  resources :couples, only: [:index, :show, :destroy] do
    get 'download', on: :collection
  end
  get 'children/download', to: 'children#download', as: 'download_children'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "people#index"
end
