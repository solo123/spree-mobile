Rails.application.routes.draw do
  # Add your extension routes here
  resources :products
  root :to => 'home#index', :as => 'home'
  match 'etl/:action' => 'etl'
  match 'pages/:id' => 'pages#index'
  match 'quotations' => 'quotations#index'
  match 'quotations/:action' => 'quotations'
  match 'account/:action' => 'users'
  match 'brands' => 'brands#index'
  match 'etl/:action' => 'etl'
  resources :profiles
  resources :addresses

  match '/ta/*id/s/*product_group_query' => 'taxons#show_all'
  match 'ta/*id/pg/:product_group_name' => 'taxons#show_all'

  #   # route globbing for pretty nested taxon and product paths
  match '/ta/*id' => 'taxons#show_all'


  namespace :admin do
    resources :uploads
    resources :import_csvs
    resources :product_taxons
    resources :quotes
    resources :suppliers
  end
end
