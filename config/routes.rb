Transferur::Application.routes.draw do
  root "student_pages#home"

  # Request form
  match "/update_transfer_courses", to: "student_pages#update_transfer_courses", via: "get"
  match "/new_transfer_request",    to: "student_pages#new_transfer_request",    via: "post"

  # Admin
  resources :schools, path: "admin/schools/",
                      only: [:index, :new, :create, :edit, :update, :destroy]
  resources :courses, path: "admin/schools/:school_id/courses/",
                      only: [:new, :create, :edit, :update, :destroy]

  # Devise
  devise_for :users, path: "",
                     path_names: { sign_in: "login", sign_out: "logout" },
                     skip: :registrations
  as :user do
    get "admin/user" => "devise/registrations#edit",   as: "edit_user_registration"
    put "admin/:id"  => "devise/registrations#update", as: "user_registration"
  end
end
