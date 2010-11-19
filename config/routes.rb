Rails.application.routes.draw do
  # Add your extension routes here
  root :to => 'home#index', :as => 'home'
  match '/etl/:action' => 'etl', :method => :action
  match '/pages/:id' => 'pages#index'
  match '/quotations' => 'quotations#index'
  match '/quotations/:action' => 'quotations', :method => :action
  match '/account/:action' => 'users', :method => :action
  match '/brands' => 'brands#index'
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
