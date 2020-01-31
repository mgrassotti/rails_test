Rails.application.routes.draw do
  root "widgets#index"
  resources :widgets
  resources :users
end
