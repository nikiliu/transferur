Transferur::Application.routes.draw do
  root "student_pages#home"

  match "/update_transfer_courses", to: "student_pages#update_transfer_courses", via: "get"
  match "/new_transfer_request",    to: "student_pages#new_transfer_request",    via: "post"
end
