Calteach::Application.routes.draw do
  devise_for :users

  resources :items do
    member do
      get 'checkout'
    end
  end

  resources :reservations do
    member do
      post 'checkout'
      put 'checkin'
    end
  end

  namespace 'admin' do
    resources :users
  end

  root :to => 'items#index'
end
