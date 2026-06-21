Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { confirmations: 'users/confirmations',
                                    omniauth_callbacks: 'users/omniauth_callbacks',
                                    sessions: 'users/sessions',
                                    registrations: 'users/registrations' }
  resources :people, path: :individuos do
    resources :couples, path: :casais do
      resources :children, path: :filhos
    end
    resources :favorites, only: [:create, :destroy]
    get 'download', on: :collection
    get 'search_child', on: :collection
    get 'search_mate', on: :collection
    get 'birthdays', on: :collection
  end
  resources :users, path: :usuarios do
    get 'mcp_access', on: :collection
    post 'mcp_token', on: :collection, to: 'users#regenerate_mcp_token', as: :regenerate_mcp_token
    delete 'mcp_token', on: :collection, to: 'users#revoke_mcp_token', as: :revoke_mcp_token
    get 'roles', on: :collection
    get 'download', on: :collection
    patch 'role_update', on: :member
    patch 'change/:locale', to: 'users#change', as: 'locale_change'
    patch 'change_unidentified/:locale', on: :collection, to: 'users#change_unidentified', as: 'locale_change_unidentified'
  end
  resources :roles, only: [:index] do
    get 'download', on: :collection
  end
  resources :events, only: [:index] do
    get 'download', on: :collection
  end
  resources :couples, path: :casais, only: %i[index show destroy] do
    get 'download', on: :collection
  end
  get 'children/download', to: 'children#download', as: 'download_children'
  get 'about', to: 'pages#about', as: 'about'
  get 'statistics', to: 'pages#statistics', as: 'statistics'
  root 'people#index'
end
