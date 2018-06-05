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

  get 'recommend/index', to: 'recommend#index', as: 'recommends'

  resources :warning_report, only:[:index,:edit,:show,:update,:destroy]
  get 'warning_report/create/:id', to: 'warning_report#create', as: 'create_warning_report'

  get 'books/search', to: 'books#search'
  resources :books

  get 'reviews/add_bookshelf:id', to: 'reviews#add_bookshelf', as: 'add_bookshelf'
  get 'reviews/index_my_bookshelf', to: 'reviews#index_my_bookshelf', as: 'my_bookshelf'
  get 'reviews/index_search_review/:id', to: 'reviews#index_search_review', as: 'search_review'
  resources :reviews

  resources :users , only:[:show]

  #管理サイト
  get 'admins/top', to: 'admins#top', as: 'admin_top'
  resources :admins
  namespace :admins do
    resources :users, only:[:index,:edit,:show,:update,:destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
