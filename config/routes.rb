Rails.application.routes.draw do
  # Add your extension routes here
  root :to => 'home#index', :as => 'home'
  match 'etl/:action' => 'etl'
  match '/pages/:id' => 'pages#index'
  match 'quotations' => 'quotations#index'
  match 'quotations/:action' => 'quotations'
  match '/account/:action' => 'users'
  match 'brands' => 'brands#index'
  match 'etl/:action' => 'etl'
  resources :profiles
  resources :addresses

  namespace :admin do
    resources :uploads
    resources :import_csvs
    resources :product_taxons
    resources :quotes
    resources :suppliers
  end
end
