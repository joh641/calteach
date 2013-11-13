Calteach::Application.routes.draw do
  devise_for :users

  get 'users/reservations'

  resources :items do
    member do
      get 'checkout'
      get 'reserve'
    end
  end

  resources :reservations do
    member do
      post 'checkout'
      put 'checkout'
      put 'checkin'
      put 'archive'
      put 'cancel'
    end
  end

  namespace 'admin' do
    resources :users
    resources :items
  end

  root :to => 'items#index'
end
