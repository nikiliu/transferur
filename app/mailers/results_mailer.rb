class ResultsMailer < ActionMailer::Base
  default from: "noreply@richmond.edu"

  def result_email(params, options)
    @request         = params[:pending_request]
    @other_school    = @request[:transfer_school_other] == "1"
    @other_course    = @request[:transfer_course_other] == "1"
    @online          = params[:online]                  == "1"
    @dual_enrollment = params[:dual_enrollment]         == "1"
    @options         = options
    mail(to: @request[:requester_email], subject: "UR Math Course Transfer Request")
  end
end
