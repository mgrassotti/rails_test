Rails.application.routes.draw do
  root "widgets#index"
  resources :widgets
  resources :users do
    resources :widgets
  end
  post '/accesses', to: 'accesses#create', as: 'sign_in'
  delete '/accesses', to: 'accesses#destroy', as: 'sign_out'
end
