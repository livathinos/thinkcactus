Thinkcactus::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  get "about/index"

  get "comments/index"

  get "work" => "work#index"

  get "posts/index"

  resources :posts do
    resources :comments
  end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "posts#index"

  # See how all your routes lay out with "rake routes"
  get '/about', to: 'about#index'

  get '/feed', to: 'posts#feed', as: :feed, defaults: { format: 'atom' }
end
