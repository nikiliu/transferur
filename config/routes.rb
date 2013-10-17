Transferur::Application.routes.draw do
  root "student_pages#home"

  match "/update_transfer_courses", to: "student_pages#update_transfer_courses", via: "get"
  match "/new_transfer_request",    to: "student_pages#new_transfer_request",    via: "post"

  devise_for :users, path: "",
                     path_names: { sign_in: "login", sign_out: "logout" },
                     skip: :registrations
  as :user do
    get "admin/user" => "devise/registrations#edit",   as: "edit_user_registration"
    put "admin/:id"  => "devise/registrations#update", as: "user_registration"
  end
end
