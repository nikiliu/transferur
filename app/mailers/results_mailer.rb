class ResultsMailer < ActionMailer::Base
  default from: "noreply@richmond.edu"

  def result_email(params, options)
    @request         = params[:pending_request]
    @other_school    = (@request[:transfer_school_other] == "1" or @request[:transfer_school_other])
    @other_course    = (@request[:transfer_course_other] == "1" or @request[:transfer_course_other])
    @dual_enrollment = (@request[:dual_enrollment]       == "1" or @request[:dual_enrollment])
    @online          = (params[:online]                  == "1")
    @options         = options
    mail(to: @request[:requester_email], subject: "UR Math Course Transfer Request")
  end
end
