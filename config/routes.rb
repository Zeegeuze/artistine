Rails.application.routes.draw do
  get 'home', to: 'pages#home', as: :home
  get 'about', to: 'pages#about', as: :about
  get 'contact', to: 'pages#contact', as: :contact
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # resources :collections do
  #   member do
  #     delete :delete_image_attachment
  #   end
  # end
  
  resources :artworks, except: [:edit] do
    member do
      get 'listing'
      delete :delete_image_attachment
    end
  end

  root to: 'pages#home'
end
