FlixelLights::Application.routes.draw do

  get "smart_story/:story_id/composer/:page_number", :to => "smart_story#composer", 
  :as => "smart_story_composer"
  
  namespace :smart_story do
    get "new_story"
    get "register"
    get "echo"
    put "echo"
  end

  resources :story_pages

  resources :story_texts

  resources :story_images

  resources :stories do 
    member do 
      get :ipad_output
    end
  end

  resources :mappers

  resources :tasks

  resources :commands

  resources :tags 
  

  resource :composer, only: :index do
    get "/", :to =>  "composer#index"
    
    collection do 
      get "library_selector", :to => "composer#library_selector"
    end
    # get "diary"
  end

  # TEMPORARY
  get "composer/test"

  namespace :study do
      get "index"
      get "info"
      get "task"
      post "save_info"
  end
  resources :library do
    collection do
      get "/", :to => "behaviors#index"
    end
  end
     
  devise_for :users

  resources :flavors

  resources :actuations

  resources :experiments

  resources :actuators



  root "application#index", :as => "home"

  
  get "light/view"
  get "light/wave"
  get "light/lb"
  get "light/index"
  get "light/synthesize"
  get "light/sequence"
  get "light/blinkm"
  post "light/create"

  get "behaviors/index"
  get "behaviors/new_stack"
  get "behaviors/new_wave"
  get "behaviors/record_wave"
  get "behaviors/get_states"
  post "behaviors/json_to_cpp"
  post "behaviors/create"
  resources :behaviors

  # Create scope for API calls
  scope '/api' do

    resources :actuators, :defaults => { :format => 'json'} do
      collection do 
        get "counts"
      end
      member do 
        get "flavors"
      end
    end
    resources :behaviors, :defaults => { :format => 'json'} do
      get 'sparse'
      collection do
        post 'scanner'
      end
    end
    resources :flavors, :defaults => { :format => 'json'} do
      collection do 
        get "counts"
      end
      member do
        get "behaviors"
        get "tags"
      end
    end 
    resources :tags, :defaults => { :format => 'json'} do
        collection do 
          get 'behaviors' 
        end
    end
    namespace :tasks, :defaults => { :format => 'json'}  do
        get 'schedule', :path => "/:id/schedule"
    end
  end

  post "sequences/json_to_cpp"
  post "sequences/create"
  resources :sequences

  post "schemes/create"
  resources :schemes

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
