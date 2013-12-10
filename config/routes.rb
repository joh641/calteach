Calteach::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations' }

  resources :items do
    member do
      get 'checkout'
      put 'unarchive'
    end
    collection do
      post 'import'
      put 'update_due_date_categories'
      delete 'delete_due_date_category'
    end
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
