Rails.application.routes.draw do
  resources :list_items, only: [:new, :create, :index]
end
