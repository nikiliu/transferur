module PendingRequestsHelper
  def pending_request_display(request)
    transfer_school_name = request.transfer_school_name
    transfer_course_num  = request.transfer_course_num
    ur_course            = School.first.courses.find_by(id: request.ur_course_id)

    if not request.transfer_school_other
      transfer_school_name = School.find_by(id: request.transfer_school_id).name
    end

    if not request.transfer_course_other
      transfer_course_num = School.find_by(id: request.transfer_school_id).courses
                                  .find_by(id: request.transfer_course_id).course_num
    end

    "#{transfer_school_name} #{transfer_course_num} => UR #{ur_course.course_num}"
  end
end
