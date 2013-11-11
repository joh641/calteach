Calteach::Application.routes.draw do
  devise_for :users

  resources :items do
  	get  :reserve, :on => :member, :as => :reserve
  end

  namespace 'admin' do
    resources :users
  end

  root :to => 'items#index'
end
