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
  resources :books

  get 'reviews/add_bookshelf:id', to: 'reviews#add_bookshelf'
  get 'reviews/index_my_bookshelf', to: 'reviews#index_my_bookshelf', as: 'my_bookshelf'
  resources :reviews

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
