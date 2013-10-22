class AdminMailer < ActionMailer::Base
  default from: "noreply@richmond.edu"

  def pending_request_notification
    to_email = User.first.email
    mail(to: to_email, subject: "New Pending Request | UR Math Course Transfer Request")
  end
end
