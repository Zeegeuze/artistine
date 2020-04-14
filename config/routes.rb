Rails.application.routes.draw do
  get 'home', to: 'pages#home', as: :home
  get 'about', to: 'pages#about', as: :about
  get 'contact', to: 'pages#contact', as: :contact
  get 'artwork', to: 'pages#artwork', as: :artwork
  get 'artwork_details/:id', to: 'pages#artwork_show', as: :artwork_id
  
  resources :remarks, only: [:create]

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root to: 'pages#home'

  namespace :admin do
    resources :remarks, only: [:index, :show, :destroy] do
      resources :answer_remarks
    end
  end
end
