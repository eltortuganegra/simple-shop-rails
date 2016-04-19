Rails.application.routes.draw do


  # Root page
  root 'site#index'

  # Static pages
  get 'about' => 'about#index'
  get 'policies/terms_of_service'
  get 'policies/privacy'
  get 'policies/cookies' => 'policies#cookies_terms'
  get 'support/faq' => 'support#faq'
  get 'support/rules' => 'support#rules'
  get 'support/contact' => 'support#contact'
  post 'support/contact' => 'support#contact'
  get 'press' => 'press#index'

  # Login and logout
  get 'login' => 'users#login'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#delete'

  # Register process
  get 'signup' => 'users#new'
  get 'confirm_account' => 'users#confirm_account'
  post 'confirm_account' => 'users#validate_confirm_account'

  #recovery password
  get 'recovery_password' => 'recovery_password#index'
  match 'recovery_password/confirm_code' => 'recovery_password#confirm_code', via: [:get, :post]
  match 'recovery_password/confirm_new_password' => 'recovery_password#confirm_new_password', via: [:get, :post]
  post 'recovery_password/set_new_password' => 'recovery_password#set_new_password'

  # Users
  resources :users

  #products
  patch 'products/:id/disable' => 'products#disable', as: :disable_product
  patch 'products/:id/enable' => 'products#enable', as: :enable_product
  resources :products

  #cart
  match 'cart' => 'cart#index', via: [:get, :post]
  post '/cart/add' => 'cart#add'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'


  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
