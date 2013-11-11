Calteach::Application.routes.draw do
  devise_for :users

  resources :items do
  	get  :reserve, :on => :member, :as => :reserve
    member do
      get 'checkout'
    end
  end

  resources :reservations do
    member do
      post 'checkout'
      put 'checkout'
      put 'checkin'
      put 'archive'
    end
  end

  namespace 'admin' do
    resources :users
  end

  root :to => 'items#index'
end
