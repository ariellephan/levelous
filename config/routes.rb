ActionController::Routing::Routes.draw do |map|
  map.resources :notifications

  map.resources :quests
  map.resources :feedbacks
  map.resources :pics
  map.resource :user_session
#  map.resource :account, :controller => "users"
  map.resources :users do |user|
    user.resources :friends
    user.resources :pics
  end
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.browse 'browse', :controller => 'welcome', :action => 'browse'
  map.top_pics 'top_pics', :controller => 'pics', :action => 'show_top'
  map.hot_pics 'hot_pics', :controller => 'pics', :action => 'show_hot'
  map.new_pics 'new_pics', :controller => 'pics', :action => 'show_new'
  map.more_search 'more_search', :controller => 'search', :action => 'more'
  map.more_pics 'more_pics', :controller => 'users', :action => 'more_pics'
  map.more_posts 'more_posts', :controller => 'users', :action => 'more_posts'
  map.more_comments 'more_comments', :controller => 'pics', :action => 'more_comments'
  map.welcomemore 'welcomemore', :controller => 'welcome', :action => 'more'
  map.more 'more', :controller => 'pics', :action => 'more'
  map.about 'about', :controller => 'footer', :action => 'about'
  map.terms 'terms', :controller => 'footer', :action => 'terms'
  # map.faq 'faq', :controller => 'footer', :action => 'faq'
  map.complete 'quests/:id/complete', :controller => 'quests', :action => 'complete'
  map.search 'search/:action', :controller => 'search'
  map.follow 'users/:id/follow', :controller => 'friends', :action => 'create'
  map.heart 'heart/:id', :controller => 'hearts', :action => 'create'
  map.logout 'logout', :controller => 'user_sessions', :action =>'destroy'
  map.login 'login', :controller => 'user_sessions', :action =>'new'
  map.logout 'logout', :controller => 'user_sessions', :action =>'destroy'
  map.signup 'signup', :controller => 'users', :action =>'new'
  map.upload 'upload', :controller => 'pics', :action =>'new'
  map.leaderboard 'leaderboard', :controller => 'users', :action =>'index'
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'
  map.feed 'feed', :controller => 'feed', :action => 'index'
  map.more_feed 'more_feed', :controller => 'feed', :action => 'more_feed'
  map.random 'random', :controller => 'pics', :action => 'random'
  map.more_leaderboard 'more_leaderboard', :controller => 'users', :action => 'more'
  map.tag 'tag/:tag', :controller => 'tags', :action => 'pics'
  map.following 'users/:id/following', :controller => 'friends', :action => 'following'
  map.followers 'users/:id/followers', :controller => 'friends', :action => 'followers'

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => 'welcome', :action =>'index'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
 
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
