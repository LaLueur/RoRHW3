Rails.application.routes.draw do

  get 'sessions/login'

  get 'sessions/logout'

  post 'sessions' => 'sessions#create'

  resources :posts
  # GET	/posts	posts#index	display a list of all photos
  # GET	/posts/new	posts#new	return an HTML form for creating a new photo
  # POST	/posts	posts#create	create a new photo
  # GET	/posts/:id	posts#show	display a specific photo
  # GET	/posts/:id/edit	posts#edit	return an HTML form for editing a photo
  # PATCH/PUT	/posts/:id	posts#update	update a specific photo
  # DELETE	/posts/:id	posts#destroy	delete a specific photo
  get 'registration' => 'users#new'#, as: 'registration'
  post 'users' => 'users#create'
  # get 'registration' => 'users#new', as: 'registration'

  # posts_path
  # post_path(:id)
  # new_post_path
  # ...

  get 'pages/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'posts#index'

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
  resources :posts do
    resources :comments do
      post :vote
    end
    post :vote
  end

end

