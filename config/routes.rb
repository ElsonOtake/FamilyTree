Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { confirmations: 'users/confirmations',
                                    omniauth_callbacks: 'users/omniauth_callbacks',
                                    sessions: 'users/sessions',
                                    registrations: 'users/registrations' }
  resources :people, path: :individuos do
    get 'descendentes-completo', on: :member, to: 'people#descendants_full'
    get 'descendentes', on: :member, to: 'people#descendants'
    get 'ascendentes', on: :member, to: 'people#ancestry'
    resources :couples, path: :casais, except: %i[show] do
      resources :children, path: :filhos
    end
    resources :favorites, only: [:create, :destroy]
    get 'search_child', on: :collection
    get 'search_mate', on: :collection
    get 'birthdays', on: :collection
  end
  resources :users, path: :usuarios do
    get 'mcp_access', on: :collection
    post 'mcp_token', on: :collection, to: 'users#regenerate_mcp_token', as: :regenerate_mcp_token
    delete 'mcp_token', on: :collection, to: 'users#revoke_mcp_token', as: :revoke_mcp_token
    get 'tree_settings', on: :collection
    patch 'tree_settings', on: :collection, action: :update_tree_settings, as: :update_tree_settings
    get 'roles', on: :collection
    patch 'role_update', on: :member
    patch 'change/:locale', to: 'users#change', as: 'locale_change'
    patch 'change_unidentified/:locale', on: :collection, to: 'users#change_unidentified', as: 'locale_change_unidentified'
  end
  resources :couples, path: :casais, only: %i[index]
  get 'about', to: 'pages#about', as: 'about'
  get 'statistics', to: 'pages#statistics', as: 'statistics'
  root 'people#index'
end
