Rails.application.routes.draw do
  
  get     '/login', to: 'sessions#new'
  post    '/login', to: 'sessions#create'
  delete  '/login', to: 'sessions#destroy'
  
  root 'static_pages#top'
  get  '/signup', to:'users#new'
  
  resources :offices
  resources :users do
    member do
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    resources :attendances, only: :update
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
