class ResultsMailer < ActionMailer::Base
  default from: "noreply@richmond.edu"

  def result_email(params, options)
    @request = params[:pending_request]
    @online  = (params[:online] == "1")
    @options = options

    # The following values check for equivalence with "1" in the case that the passed
    # params are directly from the live form, and with true in the case that they are
    # directly from a pending request.
    @other_school    = (@request[:transfer_school_other] == "1" or @request[:transfer_school_other] == true)
    @other_course    = (@request[:transfer_course_other] == "1" or @request[:transfer_course_other] == true)
    @dual_enrollment = (@request[:dual_enrollment]       == "1" or @request[:dual_enrollment]       == true)

    # Return mail object
    mail_hash = { to: @request[:requester_email], subject: "UR Math Course Transfer Request" }
    if @options[:cc_admin] == true
      admin          = User.first
      mail_hash[:cc] = admin.email
    end
    mail(mail_hash)
  end
end
