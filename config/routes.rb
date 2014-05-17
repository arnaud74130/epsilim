Epsilim::Application.routes.draw do

  root :to => "sessions#login"
  get "login", :to => "sessions#login"
  post "login_attempt", :to => "sessions#login_attempt"  
  get "logout", :to => "sessions#logout"
  #get "home", :to => "sessions#home"


  resources :exercices do
    get 'cr', :on => :member
    get 'suivi_personnel', :on => :member
    get 'a_valider', :on => :member
    get 'suivi_fonds', :on => :member
    
  end

  resources :exercices do
    resources :type_financements
  end

  resources :exercices do
    resources :fournisseurs
  end

  resources :exercices do
    resources :type_charges
    resources :type_recettes
  end


  resources :exercices do
    resources :personnes do
      # resources :activites, :controller => "activites_personne"
      # get 'activite', :on => :member
      post 'activite_supp', :on => :member
      post 'activite_create', :on => :member
      post 'activite_destroy', :on => :member
    end
  end


  resources :exercices do
    resources :chantiers do
      get 'cr', :on => :member
      resources :charges
      resources :recettes
      # resources :activites, :controller => "activites_chantier"
    end
  end


  get "exercices/:exercice_id/personnes/:id/activite" => "personnes#activite", as: :activite_exercice_personne
  get "exercices/:exercice_id/personnes/:id/suivi/:mois-:annee(/:mois2-:annee2)(/:chantier_id)" => "personnes#suivi"

  # get "exercices/:exercice_id/chantiers/:id/suivi/:mois-:annee(/:mois2-:annee2)" => "chantiers#suivi"


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root to: 'welcome#index'

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

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end