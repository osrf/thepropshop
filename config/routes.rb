PropShop::Application.routes.draw do

  get "pages/index"
  root "pages#index"

  # get "upload" => "upload#index"

  get "api" => "pages#api"
  get "contact" => "pages#contact"
  get "deploy" => "pages#deploy"

  get "about" => "pages#about"
  get "pages/about" => "pages#about"
  post "pages/search" => "pages#search"
  get "pages/search" => "pages#search"
  get "pages/contact" => "pages#contact"
  post "pages/email" => "pages#email"
  get "pages/api" => "pages#api"
  get "pages/browse/:category" => "pages#browse"

  resources :model
  resources :user

  get 'model/:id/image/:num' => 'model#image'
  get 'model/:id/sdf' => 'model#sdf'
  get 'model/:id/rate' => 'model#rate'
  get 'model/:id/download' => 'model#download'
  get 'model/:id/like/:user' => 'model#like'

  get 'user' => 'user#index'
  get 'user/:id/downloads' => 'user#downloads'
  get 'user/:id/created' => 'user#created'
  get 'user/:id/likes' => 'user#likes'

  resource :session, only: [:new, :create, :destroy]

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
