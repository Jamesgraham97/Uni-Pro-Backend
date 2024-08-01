Rails.application.routes.draw do
  get 'home/index'
  mount ActionCable.server => '/cable'
  get 'test_notification', to: 'api/v1/notifications#test_notification'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Active Storage routes
  require 'active_storage/engine'
  ActiveStorage::Engine.routes.draw do
    get '/blobs/redirect/:signed_id/*filename' => 'blobs/redirect#show', as: :rails_service_blob
    get '/blobs/proxy/:signed_id/*filename' => 'blobs/proxy#show', as: :rails_service_blob_proxy
    get '/blobs/:signed_id/*filename' => 'blobs/redirect#show'
    get '/representations/redirect/:signed_blob_id/:variation_key/*filename' => 'representations/redirect#show',
        as: :rails_blob_representation
    get '/representations/proxy/:signed_blob_id/:variation_key/*filename' => 'representations/proxy#show',
        as: :rails_blob_representation_proxy
    get '/representations/:signed_blob_id/*filename' => 'representations/redirect#show'
    get '/disk/:encoded_key/*filename' => 'disk#show', as: :rails_disk_service
    put '/disk/:encoded_token' => 'disk#update', as: :update_rails_disk_service
    post '/direct_uploads' => 'direct_uploads#create', as: :rails_direct_uploads
  end

  namespace :api do
    namespace :v1 do
      authenticate :user do
        resources :modules, only: %i[index show create update destroy] do
          resources :assignments, only: %i[create index]
        end
  
        resources :users, only: [:index]
        resources :teams do
          resources :projects do
            resources :project_assignments, only: %i[create index update destroy] do
              member do
                patch :claim
                patch :update_status
              end
            end
          end
        end
  
        resources :assignments, only: %i[index create show update destroy] do
          member do
            patch :update_status
          end
        end
  
        get 'dashboard', to: 'dashboard#index', as: :dashboard
        get 'assignments', to: 'assignments#index', as: :all_assignments
        get 'kanban', to: 'kanban#index', as: :kanban
  
        resources :friendships, only: %i[create update destroy index] do
          member do
            get :status
          end
        end
  
        resources :notifications, only: [:index] do
          member do
            post :mark_as_read
            post :respond_to_friend_request, defaults: { format: :json }
            post :respond_to_team_invite, defaults: { format: :json }
          end
        end
  
        get 'users/search', to: 'users#search', as: :user_search
        resource :profile, only: %i[show update], defaults: { format: :json }
      end
    end
  end

  # Redirect root to a basic info page or 404
  root to: 'home#index'
  get '*path', to: 'home#index', constraints: ->(request) { !request.xhr? && request.format.html? }
end
