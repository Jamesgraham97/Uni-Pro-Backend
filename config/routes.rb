Rails.application.routes.draw do
  devise_for :users
  root 'public_pages#home'
  get 'about', to: 'public_pages#about'
  get 'contact', to: 'public_pages#contact'
  get 'dashboard', to: 'dashboard#index', as: :user_root

  authenticate :user do
    resources :modules, as: :all_modules do
      resources :assignments, as: :module_assignments do
        resources :subtasks
        resources :comments
      end
    end
    # General assignments index accessible without specifying a course_module_id
    get 'assignments', to: 'assignments#index', as: :all_assignments
    get 'kanban', to: 'kanban#index', as: :kanban  # Assuming kanban is not specific to an assignment
  end
end
