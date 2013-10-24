Transferur::Application.routes.draw do
  root "pending_requests#new"

  match "/",                                  to: "pending_requests#create",                  via: "post"
  match "/update_transfer_courses",           to: "pending_requests#update_transfer_courses", via: "get"
  match "/admin/pending_requests/delete/:id", to: "pending_requests#destroy",                 via: "post"

  resources :schools,           path: "admin/schools/",                    only: [:index, :new, :create, :edit, :update, :destroy]
  resources :courses,           path: "admin/schools/:school_id/courses/", only: [:new, :create, :edit, :update, :destroy]
  resources :transfer_requests, path: "admin/transfer_requests/",          only: [:new, :create, :edit, :update, :destroy]
  resources :pending_requests,  path: "admin/pending_requests/",           only: [:index, :edit, :update]

  devise_for :users, path: "", path_names: { sign_in: "login", sign_out: "logout" }, skip: :registrations
  as :user do
    get "admin/user" => "devise/registrations#edit",   as: "edit_user_registration"
    put "admin/:id"  => "devise/registrations#update", as: "user_registration"
  end
end
