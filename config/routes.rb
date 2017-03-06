Rails.application.routes.draw do
  get 'users/show'

  get 'users/new'

	root 'static_pages#home'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/help',    to: 'static_pages#help'
	get  '/signup',  to: 'users#new'
	post '/signup',  to: 'users#create'
	resources :users  
end
