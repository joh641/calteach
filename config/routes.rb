Calteach::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations' } 

  resources :items do
    member do
      get 'checkout'
      get 'reserve'
    end
    collection { post :import }
  end

  resources :reservations do
    member do
      put 'cancel'
    end
  end

  namespace 'admin' do
    resources :users
    resources :reservations do
      member do
        post 'checkout'
        put 'checkout'
        put 'checkin'
        put 'archive'
      end
    end
  end

  root :to => 'items#index'
end
