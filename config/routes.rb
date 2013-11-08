Calteach::Application.routes.draw do
  devise_for :users

  resources :items

  namespace 'admin' do
    resources :users
  end

  root :to => 'items#index'
end
