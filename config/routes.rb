Rails.application.routes.draw do
  # Add your extension routes here
  resources :products
  root :to => 'home#index', :as => 'home'
  match 'etl/:action' => 'etl'
  match 'pages/:id' => 'pages#index'
  match 'quotations(/:action)' => 'quotations'
  match 'account/:action' => 'users'
  match 'brands' => 'brands#index'
  match 'etl/:action' => 'etl'
  resources :profiles
  resources :addresses
  match 'favorites/:action(/:id)' => 'favorites'

  match '/ta/*id/s/*product_group_query' => 'taxons#show_all'
  match 'ta/*id/pg/:product_group_name' => 'taxons#show_all'

  #   # route globbing for pretty nested taxon and product paths
  match '/ta/*id' => 'taxons#show_all'

  namespace :admin do
    resources :brands, :as => 'brands'
    match 'brands((/:id)/:action)' => 'brands'
    resources :uploads
    resources :import_csvs
    resources :product_taxons, :as => 'product_taxons'
    resources :quotes
    resources :inp_phones
    match 'quotes/:action/:id' => 'quotes'
    resources :suppliers
  end
end
