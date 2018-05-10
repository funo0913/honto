Rails.application.routes.draw do
  get 'recommend/index'

  get 'warning_report/index'

  get 'warning_report/create'

  get 'books/index'

  resources :reviews
  devise_for :admins
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
