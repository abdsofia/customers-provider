Rails.application.routes.draw do
  put 'update_import_details', to: 'import_details#update'

  resources :imports

  root to: 'imports#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
