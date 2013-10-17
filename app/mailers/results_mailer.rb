class ResultsMailer < ActionMailer::Base
  default from: "noreply@richmond.edu"

  def result_email(data)
    @name                 = data[:name]
    @email                = data[:email]
    @transfer_school      = data[:transfer_school]
    @transfer_course_name = data[:transfer_course_name]
    @transfer_course_num  = data[:transfer_course_num]
    @dual_enrollment      = data[:dual_enrollment]
    @online               = data[:online]
    @ur_course_name       = data[:ur_course_name]
    @ur_course_num        = data[:ur_course_num]
    @approved             = data[:approved]
    @reasons              = data[:reasons]
    mail(to: @email, subject: "UR Math Course Transfer Request")
  end
end
