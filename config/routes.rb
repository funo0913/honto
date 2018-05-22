Rails.application.routes.draw do
  root to: 'users#top'

  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }

  get 'recommend/index'

  get 'warning_report/index'

  get 'warning_report/create'

  get 'books/search', to: 'books#search'
  # get 'books/show', to: 'books#show'
  # post 'books/create', to: 'books#create'
  resources :books

  resources :reviews

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
