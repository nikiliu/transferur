Transferur::Application.routes.draw do
  root "student_pages#home"

  match "/new_transfer_request", to: "student_pages_controller#new_transfer_request", via: "post"
end
