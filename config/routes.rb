Calteach::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations' }

  resources :items do
    member do
      get 'checkout'
      put 'unarchive'
    end
    collection { post :import }
  end

  resources :reservations do
    member do
      put 'cancel'
    end
  end

  namespace 'admin' do
    resources :users do
      member do
        put 'activate'
      end
    end
    resources :reservations do
      member do
        post 'checkout'
        put 'checkout'
        put 'checkin'
      end
      collection do
        get 'filter'
      end
    end
  end

  root :to => 'items#index'
end
