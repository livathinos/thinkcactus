Rails.application.routes.draw do

  match "/admin" => redirect("/admin/dashboard")

  namespace :admin do

    resource :dashboard, :only => [:show], :controller => :dashboard

    if Typus.authentication == :session
      resource :session, :only => [:new, :create, :destroy], :controller => :session
      resources :account, :only => [:new, :create, :show, :forgot_password] do
        collection { get :forgot_password }
      end
    end

  end

  match ':controller(/:action(/:id(.:format)))', :controller => /admin\/[^\/]+/

end
